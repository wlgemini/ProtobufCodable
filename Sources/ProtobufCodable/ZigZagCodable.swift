

extension SignedInteger {
    
    @inline(__always)
    func _zigzagEncode<T>() -> T where T: UnsignedInteger {
        let ls: Self = self << 1
        let rs: Self = self >> (self.bitWidth - 1)
        return T(rs ^ ls)
    }
}

extension UnsignedInteger {
    
    @inline(__always)
    func _zigzagDecode<T>() -> T where T: SignedInteger {
        let ls: T = -T(self & 1)
        let rs: T = T(self >> 1)
        return ls ^ rs
    }
}


extension Int8 {
    
    @inline(__always)
    public func zigzagEncode() -> UInt8 {
        self._zigzagEncode()
    }
}


extension Int16 {
    
    @inline(__always)
    public func zigzagEncode() -> UInt16 {
        self._zigzagEncode()
    }
}

extension Int32 {
    
    @inline(__always)
    public func zigzagEncode() -> UInt32 {
        self._zigzagEncode()
    }
}

extension Int64 {
    
    @inline(__always)
    public func zigzagEncode() -> UInt64 {
        self._zigzagEncode()
    }
}


extension UInt8 {
    
    @inline(__always)
    public func zigzagDecode() -> Int8 {
        self._zigzagDecode()
    }
}

extension UInt16 {
    
    @inline(__always)
    public func zigzagDecode() -> Int16 {
        self._zigzagDecode()
    }
}

extension UInt32 {
    
    @inline(__always)
    public func zigzagDecode() -> Int32 {
        self._zigzagDecode()
    }
}

extension UInt64 {
    
    @inline(__always)
    public func zigzagDecode() -> Int64 {
        self._zigzagDecode()
    }
}
