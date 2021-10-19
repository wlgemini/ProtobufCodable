

final class _ByteBufferReader {
    
    typealias Returns<Value> = (readRang: Range<Int>, value: Value)
    
    @inlinable
    var index: Int { self._index }
    
    @inlinable
    var count: Int { self._pointer.count }
    
    /// Allocate memory and copy from source
    init<S>(from source: S) throws
    where S: Collection, S.Element == UInt8 {
        self._index = 0
        self._pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: source.count, alignment: 1)
        self._pointer.copyBytes(from: source)
    }
    
    deinit {
        self._pointer.deallocate()
    }
    
    // MARK: Private
    private var _index: Int
    private var _pointer: UnsafeMutableRawBufferPointer
}

extension _ByteBufferReader {
    
    func skipBytes(count: Int) throws -> Range<Int> {
        let lowerBound: Int = self._index
        let upperBound: Int = lowerBound + count
        guard upperBound <= self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        self._index = upperBound
        let readRange = lowerBound ..< upperBound
        return readRange
    }
    
    func skipVarint() throws -> Range<Int> {
        let lowerBound: Int = self._index
        
        while true {
            let (_, byte) = try self.readByte()
            if (byte & 0b1000_0000) != 0b1000_0000 {
                break
            }
        }
        
        // returns
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
    }
}

extension _ByteBufferReader {
    
    @inlinable
    func readByte() throws -> (readIndex: Int, value: UInt8) {
        guard self._index < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        let readIndex: Int = self._index
        let value: UInt8 = self._pointer[readIndex]
        self._index += 1
        return (readIndex, value)
    }
    
    /// formed as little-endian representation
    func readFixedWidthInteger<T>(_ type: T.Type) throws -> (readRange: Range<Int>, value: T)
    where T: FixedWidthInteger {
        let lowerBound: Int = self._index
        let valueByteCount = _Integer.bit2ByteScalar(T.bitWidth)
        let upperBound: Int = lowerBound + valueByteCount
        guard upperBound <= self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        let value: T = self._pointer.load(fromByteOffset: self._index, as: T.self)
        self._index = upperBound
        let readRange = lowerBound ..< upperBound
        return (readRange, value)
    }
    
    func readVarint<T>(_ type: T.Type) throws -> (readRange: Range<Int>, isTruncating: Bool, value: T)
    where T: FixedWidthInteger {
        let lowerBound: Int = self._index
        
        var isTruncating: Bool = false
        var value: T = 0b0000_0000
        var bitIndex: Int = 0
        let bitCount: Int = T.bitWidth
        var hasVarintFlagBit: Bool = false
        while true {
            // read a varint byte
            let (_, varintByte) = try self.readByte()
            
            // value update
            let byte: UInt8 = varintByte & 0b0111_1111
            value |= T(byte) << bitIndex
            
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
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return (readRange, isTruncating, value)
    }
}
