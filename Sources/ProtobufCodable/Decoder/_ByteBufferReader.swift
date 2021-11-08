

final class _ByteBufferReader {
    
    /// [fieldNumber: int32|int64|uint32|uint64|sint32|sint64|bool|enum]
    private(set) var mapVarint: [Swift.UInt32: Swift.UInt64] = [:]
    
    /// [fieldNumber: fixed32|sfixed32|float]
    private(set) var mapBit32: [Swift.UInt32: Swift.UInt32] = [:]
    
    /// [fieldNumber: fixed64|sfixed64|double]
    private(set) var mapBit64: [Swift.UInt32: Swift.UInt64] = [:]
    
    /// [fieldNumber: Bytes|String|Model|Packed Repeated Scalar Value's Ranges]
    private(set) var mapLengthDelimited: [Swift.UInt32: [Swift.Range<Swift.Int>]] = [:]
    
    /// Allocate memory and copy from source
    init<C>(from collection: C, in range: Swift.Range<Swift.Int>) throws
    where C: Swift.RandomAccessCollection, C.Index == Swift.Int, C.Element == Swift.UInt8 {
        // save
        assert(range.upperBound <= collection.count, "Range is out of bounds")
        self._collection = AnyCollection<C.Element>(collection)
        
        // read
        var index: Swift.Int = 0
        while (range.lowerBound + index) < range.upperBound {
            // keyVarintDecode
            let (keyReadRange, keyIsTruncating, keyValue) = Self.readVarint(valueType: Swift.UInt32.self, fromIndex: index, collection: collection)
            index = keyReadRange.upperBound
            if keyIsTruncating {
                // must not truncating `key`
                throw ProtobufDeccodingError.corruptedData("Varint decode: `key` truncated")
            }
            
            // key
            let key = Key(rawValue: keyValue)
            
            // key.wireType
            switch key.wireType {
            case .varint:
                // read varint as biggest `UInt64`
                let (payloadReadRange, payloadIsTruncating, payloadValue) = Self.readVarint(valueType: Swift.UInt64.self, fromIndex: index, collection: collection)
                
                if payloadIsTruncating {
                    // must not truncating `key`
                    throw ProtobufDeccodingError.corruptedData("Varint decode: `payload` truncated")
                }

                // next key index
                index = payloadReadRange.upperBound
                
                // save payload value
                self.mapVarint[key.fieldNumber] = payloadValue
                
            case .bit32:
                let (bit32ReadRange, bit32Value) = Self.readFixedWidthInteger(valueType: Swift.UInt32.self, fromIndex: index, collection: collection)
                
                // next key index
                index = bit32ReadRange.upperBound
                
                // save payload value
                self.mapBit32[key.fieldNumber] = bit32Value
                
            case .bit64:
                let (bit64ReadRange, bit64Value) = Self.readFixedWidthInteger(valueType: Swift.UInt64.self, fromIndex: index, collection: collection)
                
                // next key index
                index = bit64ReadRange.upperBound
                
                // save payload value
                self.mapBit64[key.fieldNumber] = bit64Value
                
            case .lengthDelimited:
                let (lengthDelimitedReadRange, lengthDelimitedIsTruncating, lengthDelimitedValue) = Self.readVarint(valueType: Swift.UInt32.self, fromIndex: index, collection: collection)
                
                if lengthDelimitedIsTruncating {
                    throw ProtobufDeccodingError.corruptedData("varint decode: `lengthDelimited.length` truncated")
                }
                
                // payload index
                index = lengthDelimitedReadRange.upperBound

                // save lengthDelimited payload range
                let lengthDelimitedByteLowerBound = index
                let lengthDelimitedByteUpperBound = index + Swift.Int(lengthDelimitedValue)
                let lengthDelimitedByteRange = lengthDelimitedByteLowerBound ..< lengthDelimitedByteUpperBound
                if var lengthDelimitedByteRanges = self.mapLengthDelimited[key.fieldNumber] {
                    lengthDelimitedByteRanges.append(lengthDelimitedByteRange)
                    self.mapLengthDelimited[key.fieldNumber] = lengthDelimitedByteRanges
                } else {
                    self.mapLengthDelimited[key.fieldNumber] = [lengthDelimitedByteRange]
                }
                
                // next key index
                index = index + lengthDelimitedByteUpperBound
                
            case .unknow:
                throw ProtobufDeccodingError.unknowWireType
            }
        }
    }
    
    // MARK: Private
    private let _collection: AnyCollection<UInt8>
}


extension _ByteBufferReader {
    
    /// formed as little-endian representation
    static func readFixedWidthInteger<V, C>(valueType: V.Type, fromIndex: Swift.Int, collection: C) -> (readRange: Swift.Range<Swift.Int>, value: V)
    where V: Swift.FixedWidthInteger, C: RandomAccessCollection, C.Index == Swift.Int, C.Element == Swift.UInt8 {
        let lowerBound: Swift.Int = fromIndex
        
        var index = fromIndex
        var value: V = 0b0000_0000
        let bitCount: Int = V.bitWidth
        var bitIndex: Int = 0
        while bitIndex < bitCount {
            /* using `RandomAccessCollection` to ensure O(1) complexity*/
            assert(index < collection.count, "Index out of bounds")
            
            // read a byte
            let byte = collection[index]
            
            // value update
            value |= V(byte) << bitIndex
            
            // next bitIndex/index
            bitIndex += 8
            index += 1
        }
        
        let upperBound = index
        let readRange = lowerBound ..< upperBound
        return (readRange, value)
    }
    
    
    static func readVarint<V, C>(valueType: V.Type, fromIndex: Swift.Int, collection: C) -> (readRange: Swift.Range<Swift.Int>, isTruncating: Swift.Bool, value: V)
    where V: Swift.FixedWidthInteger, C: RandomAccessCollection, C.Index == Swift.Int, C.Element == Swift.UInt8 {
        let lowerBound: Swift.Int = fromIndex
        
        var index = fromIndex
        var isTruncating: Swift.Bool = false
        var value: V = 0b0000_0000
        var bitIndex: Swift.Int64 = 0
        let bitCount: Swift.Int64 = Swift.Int64(V.bitWidth)
        var hasVarintFlagBit: Swift.Bool = false
        while true {
            /* using `RandomAccessCollection` to ensure O(1) complexity*/
            assert(index < collection.count, "Index out of bounds")
            
            // read a varint byte
            let varintByte: Swift.UInt8 = collection[index]
            index += 1
            
            // value update
            let byte: Swift.UInt8 = varintByte & 0b0111_1111
            value |= V(byte) << bitIndex
            
            // has varint flag bit (has more byte to read)
            hasVarintFlagBit = (varintByte & 0b1000_0000) == 0b1000_0000
            if hasVarintFlagBit == false {
                // no more byte to read
                break
            }
            
            // next index
            bitIndex += 7
            if bitIndex >= bitCount {
                isTruncating = true
            }
        }
        
        // returns
        let upperBound = index
        let readRange = lowerBound ..< upperBound
        return (readRange, isTruncating, value)
    }
}
