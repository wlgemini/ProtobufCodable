

final class _ByteBufferWriter {
    
    @inlinable
    var index: Swift.Int { self._index }
    
    @inlinable
    var count: Swift.Int { self._pointer.count }
    
    /// Allocate memory but not initialize
    init() {
        self._index = 0
        self._pointer = Self._malloc(capacity: _Integer.nextPowerOf2ClampedToUInt32Max(0))
    }
    
    deinit {
        self._pointer.deallocate()
    }
    
    // MARK: Private
    private var _index: Swift.Int
    private var _pointer: Swift.UnsafeMutableRawBufferPointer
    
    private static func _malloc(capacity: Swift.UInt32) -> Swift.UnsafeMutableRawBufferPointer {
        return Swift.UnsafeMutableRawBufferPointer.allocate(byteCount: Swift.Int(capacity), alignment: 1)
    }
    
    private func _realloc() {
        let oldCapacity = Swift.UInt32(self._pointer.count)
        let newCapacity = _Integer.nextPowerOf2ClampedToUInt32Max(oldCapacity)
        Swift.assert(newCapacity > oldCapacity, "can not alloc more memory")
        
        let newPointer = Self._malloc(capacity: newCapacity)
        newPointer.copyMemory(from: UnsafeRawBufferPointer(self._pointer))
        self._pointer.deallocate()
        self._pointer = newPointer
    }
}

extension _ByteBufferWriter {
    
    @inlinable
    func getByte(at index: Swift.Int) -> Swift.UInt8 {
        let byte: Swift.UInt8 = self._pointer[index]
        return byte
    }
}

extension _ByteBufferWriter {
    
    
    @discardableResult
    @inlinable
    /// write byte
    /// - Parameter value: byte
    /// - Returns: write index
    func writeByte(_ value: Swift.UInt8) -> Swift.Int {
        let index = self._index
        if index < self._pointer.count {
            self._pointer[index] = value
        } else {
            self._realloc()
            self._pointer[index] = value
        }
        self._index += 1
        return index
    }

    /// formed as little-endian representation
    func writeFixedWidthInteger<T>(_ value: T) -> Swift.Range<Int>
    where T: Swift.FixedWidthInteger {
        let valueByteCount = _Integer.bit2ByteScalar(T.bitWidth)
        self._pointer.storeBytes(of: value.littleEndian, toByteOffset: self._index, as: T.self)
        
        let lowerBound: Int = self._index
        self._index += valueByteCount
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
    }

    @discardableResult
    func writeVarint<T>(_ value: T) -> Swift.Range<Int>
    where T: Swift.FixedWidthInteger {
        // find the Leading Non-zero Bit Index
        let lnbIndex: Swift.Int = _Integer.leadingNonZeroBitIndex(value)
        guard lnbIndex >= 0 else {
            // write one byte for 0
            let lowerBound = self.writeByte(0)
            let upperBound = self._index
            let readRange = lowerBound ..< upperBound
            return readRange
        }
        
        let lowerBound = self._index
        
        // Leading Non-zero Bit Count
        let lnbCount: Swift.Int = lnbIndex + 1
        
        // set varint flag
        var bitIndex: Swift.Int = 0
        while bitIndex < lnbCount {
            var bit8: Swift.UInt8 = _Integer.byte(value, at: bitIndex)
            bit8 = _Integer.bitTrue(bit8, at: 7)
            self.writeByte(bit8)
            bitIndex += 7
        }
        
        // set last varint flag
        let prevIndex = self._index - 1
        var bit8: Swift.UInt8 = self.getByte(at: prevIndex)
        bit8 = _Integer.bitFalse(bit8, at: 7)
        self._pointer[prevIndex] = bit8
        
        // return
        let upperBound = self._index
        let readRange = lowerBound ..< upperBound
        return readRange
    }
}
