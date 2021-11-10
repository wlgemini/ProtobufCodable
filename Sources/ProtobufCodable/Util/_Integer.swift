
enum _Integer {}

extension _Integer {
    
    /// Find the Leading non-Zero Bit index, -1 when not find
    ///
    /// `SignedInteger` has a sign bit, so it's not approperate for this calculation.
    /// (same as `mostSignificantBitIndex`)
    @inlinable
    static func leadingNonZeroBitIndex<T>(_ value: T) -> Swift.Int
    where T: Swift.FixedWidthInteger {
        value.bitWidth - value.leadingZeroBitCount - 1
    }
    
    /*
    /// Find the Leading non-Zero Bit index, -1 when not find
    var leadingNonZeroBitIndex: Int8 {
        var lb: Int8 = -1
        var rb: Int8 = Int8(MemoryLayout<Self>.size).byte2BitScalar
        
        while (lb + 1) < rb {
            let mid = (lb + rb) / 2
            if (self >> mid) != 0 {
                lb = mid
            } else {
                rb = mid
            }
        }
        
        return lb
    }
    */
    
    /// Find the Leading non-Zero Bit Count
    ///
    /// `SignedInteger` has a sign bit, so it's not approperate for this calculation.
    /// (same as `mostSignificantBitIndex`)
    @inlinable
    static func leadingNonZeroBitCount<T>(_ value: T) -> Swift.Int
    where T: Swift.FixedWidthInteger {
        value.bitWidth - value.leadingZeroBitCount
    }
}


extension _Integer {
    
    @inlinable
    static func bit2ByteScalar<T>(_ value: T) -> T
    where T: Swift.BinaryInteger {
        if (value & 0b0000_0111) == 0 {
            return value >> 3 // 没有余数
        } else {
            return (value >> 3) + 1 // 有余数
        }
    }
    
    @inlinable
    static func byte2BitScalar<T>(_ value: T) -> T
    where T: Swift.FixedWidthInteger {
        value << 3
    }
}


extension _Integer {
    
    /// get a byte from bit index
    /// - Parameter index: bit index
    /// - Returns: a byte
    @inlinable
    static func byte<T>(_ value: T, at index: Int) -> Swift.UInt8
    where T: Swift.BinaryInteger {
        assert(value.bitWidth > index)
        
        return Swift.UInt8((value >> index) & 0b1111_1111)
    }
}


extension _Integer {
    
    /// Returns the next power of two unless that would overflow, in which case UInt32.max (on 64-bit systems) or
    /// Int32.max (on 32-bit systems) is returned. The returned value is always safe to be cast to Int and passed
    /// to malloc on all platforms.
    static func nextPowerOf2ClampedToUInt32Max(_ value: Swift.UInt32) -> Swift.UInt32 {
        guard value > 0 else {
            return 1
        }

        var n = value

        #if arch(arm) || arch(i386)
        // on 32-bit platforms we can't make use of a whole UInt32.max (as it doesn't fit in an Int)
        let max = Swift.UInt32(Int.max)
        #else
        // on 64-bit platforms we're good
        let max = Swift.UInt32.max
        #endif

        n -= 1
        n |= n >> 1
        n |= n >> 2
        n |= n >> 4
        n |= n >> 8
        n |= n >> 16
        if n != max {
            n += 1
        }

        return n
    }
}


extension _Integer {
    
    /// get bit at index
    @inlinable
    static func bit<T>(_ value: T, at index: Swift.Int) -> Swift.Bool
    where T: Swift.BinaryInteger {
        assert(value.bitWidth > index)
        return (value >> index) == 0b0000_0001 ? true : false
    }
    
    /// set bit true at index
    @inlinable
    static func bitTrue<T>(_ value: T, at index: Swift.Int) -> T
    where T: Swift.BinaryInteger {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return value | mask
    }
    
    /// set bit false at index
    @inlinable
    static func bitFalse<T>(_ value: T, at index: Swift.Int) -> T
    where T: Swift.BinaryInteger {
        assert(value.bitWidth > index)

        let mask: T = ~(0b0000_0001 << index)
        return value & mask
    }
    
    /// toggle bit at index
    @inlinable
    static func bitToggle<T>(_ value: T, at index: Swift.Int) -> T
    where T: Swift.BinaryInteger {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return value ^ mask
    }
}



extension _Integer {
    
    static func varintByteCount<T>(for value: T) -> Swift.Int
    where T: Swift.FixedWidthInteger {
        let lnbIndex: Swift.Int = _Integer.leadingNonZeroBitIndex(value)
        let lnbCount: Swift.Int = _Integer.leadingNonZeroBitCount(value)
        let varintFlagBitCount: Swift.Int = (lnbIndex / 7) + 1 // every 7 bit need a varint flag
        let varintBitCount: Swift.Int = lnbCount + varintFlagBitCount
        let varintByteCount: Swift.Int = _Integer.bit2ByteScalar(varintBitCount)
        return varintByteCount
    }
}


extension _Integer {
    
    /// Return a 32-bit ZigZag-encoded value.
    @inlinable
    static func zigZagEncoded(_ value: Swift.Int32) -> Swift.UInt32 {
        return Swift.UInt32(bitPattern: (value << 1) ^ (value >> 31))
    }

    /// Return a 64-bit ZigZag-encoded value.
    @inlinable
    static func zigZagEncoded(_ value: Swift.Int64) -> Swift.UInt64 {
        return Swift.UInt64(bitPattern: (value << 1) ^ (value >> 63))
    }

    /// Return a 32-bit ZigZag-decoded value.
    @inlinable
    static func zigZagDecoded(_ value: Swift.UInt32) -> Swift.Int32 {
        return Swift.Int32(bitPattern: value >> 1) ^ -Swift.Int32(bitPattern: value & 1)
    }

    /// Return a 64-bit ZigZag-decoded value.
    @inlinable
    static func zigZagDecoded(_ value: Swift.UInt64) -> Swift.Int64 {
        return Swift.Int64(bitPattern: value >> 1) ^ -Swift.Int64(bitPattern: value & 1)
    }
}


extension _Integer {
    
    static func description<T>(_ value: T) -> Swift.String
    where T: Swift.BinaryInteger {
        var binaryString: Swift.String = ""
        withUnsafeBytes(of: self) { bufferPointer in
            for byte in bufferPointer {
                let b0 = (byte & 0b0000_0001) == 0 ? "0" : "1"
                let b1 = (byte & 0b0000_0010) == 0 ? "0" : "1"
                let b2 = (byte & 0b0000_0100) == 0 ? "0" : "1"
                let b3 = (byte & 0b0000_1000) == 0 ? "0" : "1"
                
                let b4 = (byte & 0b0001_0000) == 0 ? "0" : "1"
                let b5 = (byte & 0b0010_0000) == 0 ? "0" : "1"
                let b6 = (byte & 0b0100_0000) == 0 ? "0" : "1"
                let b7 = (byte & 0b1000_0000) == 0 ? "0" : "1"
                binaryString += "\(b7)\(b6)\(b5)\(b4)_\(b3)\(b2)\(b1)\(b0) "
            }
        }
        return binaryString
    }
}
