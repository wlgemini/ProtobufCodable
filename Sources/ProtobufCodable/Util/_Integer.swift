
enum _Integer<T> {}

extension _Integer where T: FixedWidthInteger {
    
    /// Find the Leading non-Zero Bit index, -1 when not find
    ///
    /// `SignedInteger` has a sign bit, so it's not approperate for this calculation.
    /// (same as `mostSignificantBitIndex`)
    @inlinable
    static func leadingNonZeroBitIndex(_ value: T) -> Int {
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
}


extension _Integer where T: BinaryInteger {
    
    @inlinable
    static func bit2ByteScalar(_ value: T) -> T {
        if (value & 0b0000_0111) == 0 {
            return value >> 3 // 没有余数
        } else {
            return (value >> 3) + 1 // 有余数
        }
    }
    
    @inlinable
    static func byte2BitScalar(_ value: T) -> T {
        value << 3
    }
}


extension _Integer where T: BinaryInteger {
    
    /// get a byte from bit index
    /// - Parameter index: bit index
    /// - Returns: a byte
    @inlinable
    static func byte(_ value: T, at index: Int) -> UInt8 {
        assert(value.bitWidth > index)
        
        return UInt8((value >> index) & 0b1111_1111)
    }
}


extension _Integer where T: BinaryInteger {
    
    /// get bit at index
    @inlinable
    static func bit(_ value: T, at index: Int) -> Bool {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return (value & mask) > 0 ? true : false
    }
    
    /// set bit true at index
    @inlinable
    static func bitTrue(_ value: T, at index: Int) -> T {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return value | mask
    }
    
    /// set bit false at index
    @inlinable
    static func bitFalse(_ value: T, at index: Int) -> T {
        assert(value.bitWidth > index)

        let mask: T = ~(0b0000_0001 << index)
        return value & mask
    }
    
    /// toggle bit at index
    @inlinable
    static func bitToggle(_ value: T, at index: Int) -> T {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return value ^ mask
    }
}


extension _Integer where T == UInt32 {
    
    /// Returns the next power of two unless that would overflow, in which case UInt32.max (on 64-bit systems) or
    /// Int32.max (on 32-bit systems) is returned. The returned value is always safe to be cast to Int and passed
    /// to malloc on all platforms.
    static func nextPowerOf2ClampedToMax(_ value: UInt32) -> UInt32 {
        guard value > 0 else {
            return 1
        }

        var n = value

        #if arch(arm) || arch(i386)
        // on 32-bit platforms we can't make use of a whole UInt32.max (as it doesn't fit in an Int)
        let max = UInt32(Int.max)
        #else
        // on 64-bit platforms we're good
        let max = UInt32.max
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



extension _Integer where T: BinaryInteger {
    
    static func description(_ value: T) -> String {
        var binaryString: String = ""
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
