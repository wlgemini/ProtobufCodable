

final class _ByteBuffer {
    
    @inlinable
    var index: Int { self._index }
    
    @inlinable
    var count: Int { self._pointer.count }
    
    /// Allocate memory but not initialize
    init(with capacity: Int) {
        self._index = 0
        self._pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: capacity, alignment: 1)
    }
    
    /// Allocate memory and copy from source
    init<S>(from source: S) throws
    where S: Collection, S.Element == UInt8 {
        self._index = 0
        self._pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: source.count, alignment: 1)
        let (_, initialized) = self._pointer.initializeMemory(as: S.Element.self, from: source)
        if initialized.count != source.count {
            throw ProtobufDeccodingError.corruptedData("data capacity not match")
        }
    }
    
    deinit {
        self._pointer.deallocate()
    }
    
    // MARK: Private
    private var _index: Int
    private var _pointer: UnsafeMutableRawBufferPointer
}


// MARK: - _ByteBuffer Byte
extension _ByteBuffer {
    
    @inlinable
    func readByteOne() throws -> UInt8 {
        let byte: UInt8 = try self.readByteOne(at: self._index)
        self._index += 1
        return byte
    }
    
    @inlinable
    func writeByteOne(_ value: UInt8) throws {
        try self.writeByteOne(value, at: self._index)
        self._index += 1
    }
    
    @inlinable
    func readByteOne(at index: Int) throws -> UInt8 {
        guard index < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        let byte: UInt8 = self._pointer[index]
        return byte
    }
    
    @inlinable
    func writeByteOne(_ value: UInt8, at index: Int) throws {
        guard index < self._pointer.count else {
            throw ProtobufDeccodingError.corruptedData("index out of bounds")
        }
        
        self._pointer[index] = value
    }
}


// MARK: - _ByteBuffer FixedWidthInteger
extension _ByteBuffer {
    
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
}

// MARK: - _ByteBuffer Bytes
extension _ByteBuffer {
    
    func readBytes(_ count: Int) -> Range<Int> {
        fatalError()
    }
    
    func write<S>(_ source: S) -> Range<Int>
    where S: Collection, S.Element == UInt8 {
        fatalError()
    }
}


// MARK: - _ByteBuffer Varint
extension _ByteBuffer {
    
    func readVarintOne() throws -> Range<Int> {
        let lowerBound: Int = self._index
        
        while true {
            let byte = try self.readByteOne()
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
            let varintByte: UInt8 = try self.readByteOne()
            
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
    
    @discardableResult
    func writeVarint<T>(_ value: T) throws -> Range<Int>
    where T: FixedWidthInteger {
        let lowerBound: Int = self._index
        
        // find the Leading Non-zero Bit Index
        let lnbIndex: Int = _Integer.leadingNonZeroBitIndex(value)
        guard lnbIndex >= 0 else {
            // write one byte for 0
            try self.writeByteOne(0)
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
            try self.writeByteOne(bit8)
            bitIndex += 7
        }
        
        // set last varint flag
        var bit8: UInt8 = try self.readByteOne(at: self._index - 1)
        bit8 = _Integer.bitFalse(bit8, at: 7)
        try self.writeByteOne(bit8, at: self._index - 1)
        
        // return
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
    }
}
