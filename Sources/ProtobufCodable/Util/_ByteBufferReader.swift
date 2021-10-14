

final class _ByteBufferReader {
    
    @inlinable
    var index: Int { self._index }
    
    @inlinable
    var count: Int { self._pointer.count }
    
    /// Allocate memory and copy from source
    init<S>(from source: S) throws
    where S: Collection, S.Element == UInt8 {
        self._index = 0
        self._pointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: source.count)
        _ = self._pointer.initialize(from: source)
    }
    
    deinit {
        self._pointer.deallocate()
    }
    
    // MARK: Private
    private var _index: Int
    private var _pointer: UnsafeMutableBufferPointer<UInt8>
}

extension _ByteBufferReader {
    
    @inlinable
    func getByte(at index: Int) throws -> UInt8 {
        guard index < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        let byte: UInt8 = self._pointer[index]
        return byte
    }
}

extension _ByteBufferReader {
    
    @inlinable
    func readByte() throws -> UInt8 {
        let byte: UInt8 = try self.getByte(at: self._index)
        self._index += 1
        return byte
    }

    @inlinable
    func readBytes(count: Int) throws -> Range<Int> {
        guard self._index + count < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        let lowerBound: Int = self._index
        self._index += count
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
    }
    
    /// using little-endian representation
    func readFixedWidthInteger<T>(_ type: T.Type) throws -> (readRange: Range<Int>, value: T)
    where T: FixedWidthInteger {
        let lowerBound: Int = self._index
        let valueBitCount = T.bitWidth
        let valueByteCount = _Integer.bit2ByteScalar(valueBitCount)
        guard (lowerBound + valueByteCount) < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        var value: T = 0b0000_0000
        var bitIndex: Int = 0
        var byteIndex: Int = lowerBound
        while bitIndex < valueBitCount {
            let byte = self._pointer[byteIndex]
            value |= T(byte) << bitIndex
            
            bitIndex += 8
            byteIndex += 1
        }
        
        self._index = byteIndex
        
        // returns
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return (readRange, value)
    }
    
    func readVarint() throws -> Range<Int> {
        let lowerBound: Int = self._index
        
        while true {
            let byte = try self.readByte()
            if (byte & 0b1000_0000) != 0b1000_0000 {
                break
            }
        }
        
        // returns
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
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
            let varintByte: UInt8 = try self.readByte()
            
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
