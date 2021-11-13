import Foundation


///
/// Because of COW, Dictionary may make a copy of itself before remove any Element.
/// That's why the complexity of removeValue(forKey:) is O(n).
/// So, keep Dictionary only have 1 reference to keep away from COW.
///
final class _ByteBufferReader {
    
    // MARK: Private
    let data: Data
    
    /// [fieldNumber: littleEndian.varint.bit64]
    var mapVarint: [Swift.UInt32: Swift.UInt64] = [:]
    
    /// [fieldNumber: littleEndian.bit32]
    var mapBit32: [Swift.UInt32: Swift.UInt32] = [:]
    
    /// [fieldNumber: littleEndian.bit64]
    var mapBit64: [Swift.UInt32: Swift.UInt64] = [:]
    
    /// [fieldNumber: littleEndian.[bit8].range]
    var mapLengthDelimited: [Swift.UInt32: [Swift.Range<Swift.Int>]] = [:]
    
    /// init
    init(from data: Foundation.Data, in range: Swift.Range<Swift.Int>) throws {
        assert(range.upperBound <= data.count, "Range is out of bounds")

        // save
        self.data = data
        
        // read
        var index: Swift.Int = 0
        while (range.lowerBound + index) < range.upperBound {
            // keyVarintDecode
            let (keyReadRange, keyIsTruncating, keyValue) = Self.readVarint(valueType: Swift.UInt32.self, fromIndex: index, data: data)
            if keyIsTruncating {
                // must not truncating `key`
                throw ProtobufDeccodingError.corruptedData("Varint decode: `key` truncated")
            }
            
            // next key index
            index = keyReadRange.upperBound
            
            // key
            let key = Key(rawValue: keyValue)
            
            // key.wireType
            switch key.wireType {
            case .varint:
                // read varint as biggest `UInt64`
                let (payloadReadRange, payloadIsTruncating, payloadValue) = Self.readVarint(valueType: Swift.UInt64.self, fromIndex: index, data: data)
                
                if payloadIsTruncating {
                    // must not truncating `key`
                    throw ProtobufDeccodingError.corruptedData("Varint decode: `payload` truncated")
                }

                // next key index
                index = payloadReadRange.upperBound
                
                // save payload value
                self.mapVarint[key.fieldNumber] = payloadValue
                
            case .bit32:
                let (bit32ReadRange, bit32Value) = Self.readFixedWidthInteger(valueType: Swift.UInt32.self, fromIndex: index, data: data)
                
                // next key index
                index = bit32ReadRange.upperBound
                
                // save payload value
                self.mapBit32[key.fieldNumber] = bit32Value
                
            case .bit64:
                let (bit64ReadRange, bit64Value) = Self.readFixedWidthInteger(valueType: Swift.UInt64.self, fromIndex: index, data: data)
                
                // next key index
                index = bit64ReadRange.upperBound
                
                // save payload value
                self.mapBit64[key.fieldNumber] = bit64Value
                
            case .lengthDelimited:
                let (lengthDelimitedReadRange, lengthDelimitedIsTruncating, lengthDelimitedValue) = Self.readVarint(valueType: Swift.UInt32.self, fromIndex: index, data: data)
                
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
}


extension _ByteBufferReader {
    
    /// Formated as little-endian representation
    static func readFixedWidthInteger<V>(valueType: V.Type, fromIndex: Swift.Int, data: Foundation.Data) -> (readRange: Swift.Range<Swift.Int>, value: V)
    where V: Swift.FixedWidthInteger {
        let lowerBound: Swift.Int = fromIndex
        
        var index = fromIndex
        var value: V = 0b0000_0000
        var bitIndex: Int = 0
        let bitCount: Int = V.bitWidth
        while index < data.count /* using `Data: RandomAccessCollection` to ensure O(1) complexity */ {
            // read a byte
            let byte = data[index]
            
            // next index
            index += 1
            
            // value update
            value |= V(byte) << bitIndex
            
            // next bitIndex
            bitIndex += 8
            
            if bitIndex >= bitCount {
                break
            }
        }
        
        let upperBound = index
        let readRange = lowerBound ..< upperBound
        return (readRange, value)
    }
    
    /// Formated as little-endian representation
    static func readVarint<V>(valueType: V.Type, fromIndex: Swift.Int, data: Foundation.Data) -> (readRange: Swift.Range<Swift.Int>, isTruncating: Swift.Bool, value: V)
    where V: Swift.FixedWidthInteger {
        let lowerBound: Swift.Int = fromIndex
        
        var index = fromIndex
        var value: V = 0b0000_0000
        var bitIndex: Swift.Int64 = 0
        let bitCount: Swift.Int64 = Swift.Int64(V.bitWidth)
        var hasVarintFlagBit: Swift.Bool = false
        
        while index < data.count /* using `Data: RandomAccessCollection` to ensure O(1) complexity*/ {
            // read a varint byte
            let varintByte: Swift.UInt8 = data[index]
            
            // next index
            index += 1
            
            // value update
            let byte: Swift.UInt8 = varintByte & 0b0111_1111
            value |= V(byte) << bitIndex
            
            // next bitIndex
            bitIndex += 7
            
            // has varint flag bit (has more byte to read)
            hasVarintFlagBit = (varintByte & 0b1000_0000) == 0b1000_0000
            if hasVarintFlagBit == false {
                // no more byte to read
                break
            }
            
            // is bitIndex out of bounds
            if bitIndex >= bitCount {
                break
            }
        }
        
        // returns
        let upperBound = index
        let readRange = lowerBound ..< upperBound
        let isTruncating = hasVarintFlagBit
        return (readRange, isTruncating, value)
    }
    
    /// Formated as little-endian representation
    static func readFixedWidthIntegers<V>(valueType: V.Type, range: Swift.Range<Swift.Int>, data: Foundation.Data) throws -> [V]
    where V: Swift.FixedWidthInteger {
        let byteCount: Swift.Int = _Integer.bit2ByteScalar(V.bitWidth)
        let values: [V] = try Swift.stride(from: range.lowerBound, to: range.upperBound, by: 4).map {
            let (readRange, value) = _ByteBufferReader.readFixedWidthInteger(valueType: V.self, fromIndex: $0, data: data)
            if (readRange.upperBound - readRange.lowerBound) != byteCount {
                throw ProtobufDeccodingError.corruptedData("Bytes not match to `\(V.self)`")
            }
            return value
        }
        return values
    }
    
    /// Formated as little-endian representation
    static func readVarints<V>(valueType: V.Type, range: Swift.Range<Swift.Int>, data: Foundation.Data) throws -> [V]
    where V: Swift.FixedWidthInteger {
        var values: [V] = []
        
        var index: Swift.Int = 0
        while (range.lowerBound + index) < range.upperBound {
            let (readRange, isTruncating, value) = Self.readVarint(valueType: V.self, fromIndex: index, data: data)
            if isTruncating {
                // must not truncating `V`
                throw ProtobufDeccodingError.corruptedData("Varint decode: `\(V.self)` truncated")
            }

            index = readRange.upperBound
            values.append(value)
        }
        
        return values
    }
}
