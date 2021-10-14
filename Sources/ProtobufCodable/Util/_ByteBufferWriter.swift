

final class _ByteBufferWriter {
    
    @inlinable
    var index: Int { self._index }
    
    @inlinable
    var count: Int { self._pointer.count }
    
    /// Allocate memory but not initialize
    init(with capacity: Int) {
        self._index = 0
        self._pointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: capacity)
    }
    
    deinit {
        self._pointer.deallocate()
    }
    
    // MARK: Private
    private var _index: Int
    private var _pointer: UnsafeMutableBufferPointer<UInt8>
}

extension _ByteBufferWriter {
    
    @inlinable
    func getByte(at index: Int) throws -> UInt8 {
        guard index < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        let byte: UInt8 = self._pointer[index]
        return byte
    }
    
    @inlinable
    func setByte(_ value: UInt8, at index: Int) throws {
        guard index < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        self._pointer[index] = value
    }
}

extension _ByteBufferWriter {
    
    @inlinable
    func writeByte(_ value: UInt8) throws {
        try self.setByte(value, at: self._index)
        self._index += 1
    }

    /// using little-endian representation
    func writeFixedWidthInteger<T>(_ value: T) throws -> Range<Int>
    where T: FixedWidthInteger {
        let lowerBound: Int = self._index
        let valueBitCount = T.bitWidth
        let valueByteCount = _Integer.bit2ByteScalar(valueBitCount)
        guard (lowerBound + valueByteCount) < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        var bitIndex: Int = 0
        var byteIndex: Int = lowerBound
        while bitIndex < valueBitCount {
            let byte = _Integer.byte(value, at: bitIndex)
            self._pointer[byteIndex] = byte
            
            bitIndex += 8
            byteIndex += 1
        }
        
        self._index = byteIndex
        
        // returns
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
    }

    @discardableResult
    func writeVarint<T>(_ value: T) throws -> Range<Int>
    where T: FixedWidthInteger {
        let lowerBound: Int = self._index
        
        // find the Leading Non-zero Bit Index
        let lnbIndex: Int = _Integer.leadingNonZeroBitIndex(value)
        guard lnbIndex >= 0 else {
            // write one byte for 0
            try self.writeByte(0)
            let upperBound = self._index
            let readRange = lowerBound ..< upperBound
            return readRange
        }
        
        // Leading Non-zero Bit Count
        let lnbCount: Int = lnbIndex + 1
        
        // set varint flag
        var bitIndex: Int = 0
        while bitIndex < lnbCount {
            var bit8: Byte = _Integer.byte(value, at: bitIndex)
            bit8 = _Integer.bitTrue(bit8, at: 7)
            try self.writeByte(bit8)
            bitIndex += 7
        }
        
        // set last varint flag
        var bit8: UInt8 = try self.getByte(at: self._index - 1)
        bit8 = _Integer.bitFalse(bit8, at: 7)
        try self.setByte(bit8, at: self._index - 1)
        
        // return
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
    }
}

