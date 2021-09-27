
enum _Integer {}

extension _Integer {
    
    /// Find the Leading non-Zero Bit index, -1 when not find
    ///
    /// `SignedInteger` has a sign bit, so it's not approperate for this calculation.
    /// (same as `mostSignificantBitIndex`)
    @inlinable
    static func leadingNonZeroBitIndex<T>(_ value: T) -> Int
    where T: FixedWidthInteger {
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
    static func leadingNonZeroBitCount<T>(_ value: T) -> Int
    where T: FixedWidthInteger {
        value.bitWidth - value.leadingZeroBitCount
    }
}


extension _Integer {
    
    @inlinable
    static func bit2ByteScalar<T>(_ value: T) -> T
    where T: BinaryInteger {
        if (value & 0b0000_0111) == 0 {
            return value >> 3 // 没有余数
        } else {
            return (value >> 3) + 1 // 有余数
        }
    }
    
    @inlinable
    static func byte2BitScalar<T>(_ value: T) -> T
    where T: FixedWidthInteger {
        value << 3
    }
}


extension _Integer {
    
    /// get a byte from bit index
    /// - Parameter index: bit index
    /// - Returns: a byte
    @inlinable
    static func byte<T>(_ value: T, at index: Int) -> UInt8
    where T: BinaryInteger {
        assert(value.bitWidth > index)
        
        return UInt8((value >> index) & 0b1111_1111)
    }
}


extension _Integer {
    
    /// get bit at index
    @inlinable
    static func bit<T>(_ value: T, at index: Int) -> Bool
    where T: BinaryInteger {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return (value & mask) > 0 ? true : false
    }
    
    /// set bit true at index
    @inlinable
    static func bitTrue<T>(_ value: T, at index: Int) -> T
    where T: BinaryInteger {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return value | mask
    }
    
    /// set bit false at index
    @inlinable
    static func bitFalse<T>(_ value: T, at index: Int) -> T
    where T: BinaryInteger {
        assert(value.bitWidth > index)

        let mask: T = ~(0b0000_0001 << index)
        return value & mask
    }
    
    /// toggle bit at index
    @inlinable
    static func bitToggle<T>(_ value: T, at index: Int) -> T
    where T: BinaryInteger {
        assert(value.bitWidth > index)
        
        let mask: T = 0b0000_0001 << index
        return value ^ mask
    }
}



extension _Integer {
    
    static func varintByteCount<T>(for value: T) -> Int
    where T: FixedWidthInteger {
        let lnbIndex: Int = _Integer.leadingNonZeroBitIndex(value)
        let lnbCount: Int = _Integer.leadingNonZeroBitCount(value)
        let varintFlagBitCount: Int = (lnbIndex / 7) + 1 // every 7 bit need a varint flag
        let varintBitCount: Int = lnbCount + varintFlagBitCount
        let varintByteCount: Int = _Integer.bit2ByteScalar(varintBitCount)
        return varintByteCount
    }
}



extension _Integer {
    
    static func description<T>(_ value: T) -> String
    where T: BinaryInteger {
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
