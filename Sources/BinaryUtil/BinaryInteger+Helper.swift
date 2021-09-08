

extension BinaryInteger where Self: UnsignedInteger, Self: FixedWidthInteger {
    
    /// Find the Leading non-Zero Bit index
    ///
    /// `SignedInteger` has a sign bit, so it's not approperate for this calculation.
    /// (same as `mostSignificantBitIndex`)
    @inlinable
    var leadingNonZeroBitIndex: Int {
        self.bitWidth - self.leadingZeroBitCount - 1
    }
    
    /*
    /// Find the Most Significant Bit Index, -1 when not find
    var mostSignificantBitIndex: Int8 {
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


extension BinaryInteger {
    
    @inlinable
    var bit2ByteScalar: Self {
        if (self & 0b0000_0111) == 0 {
            return self >> 3 // 没有余数
        } else {
            return (self >> 3) + 1 // 有余数
        }
    }
    
    @inlinable
    var byte2BitScalar: Self { self << 3 }
}


extension BinaryInteger {
    
    /// get a byte from bit index
    /// - Parameter index: bit index
    /// - Returns: a byte
    @inlinable
    func byte(at index: UInt8) -> UInt8 {
        assert(UInt8(self.bitWidth) > index)
        
        return UInt8((self >> index) & 0b1111_1111)
    }
}


extension BinaryInteger {
    
    /// get bit at index
    @inlinable
    func bit(at index: UInt8) -> Bool {
        // the biggest UInt128 take 128 bit, which within the range of 0 ~ 255 that UInt8 can represent.
        assert(UInt8(self.bitWidth) > index)
        
        let mask: Self = 0b0000_0001 << index
        return (self & mask) > 0 ? true : false
    }
    
    /// set bit true at index
    @inlinable
    mutating func bitTrue(at index: UInt8) {
        // the biggest UInt128 take 128 bit, which within the range of 0 ~ 255 that UInt8 can represent.
        assert(UInt8(self.bitWidth) > index)
        
        let mask: Self = 0b0000_0001 << index
        self = self | mask
    }
    
    /// set bit false at index
    @inlinable
    mutating func bitFalse(at index: UInt8) {
        // the biggest UInt128 take 128 bit, which within the range of 0 ~ 255 that UInt8 can represent.
        assert(UInt8(self.bitWidth) > index)

        let mask: Self = ~(0b0000_0001 << index)
        self = self & mask
    }
    
    /// toggle bit at index
    @inlinable
    mutating func bitToggle(at index: UInt8) {
        // the biggest UInt128 take 128 bit, which within the range of 0 ~ 255 that UInt8 can represent.
        assert(UInt8(self.bitWidth) > index)
        
        let mask: Self = 0b0000_0001 << index
        self = self ^ mask
    }
}



extension BinaryInteger {
    
    var binaryDescription: String {
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
