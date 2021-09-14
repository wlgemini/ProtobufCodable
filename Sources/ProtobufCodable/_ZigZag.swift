
enum _ZigZag {}

extension _ZigZag {
    
    @inlinable
    static func encode<Signed, Unsigned>(_ value: Signed) -> Unsigned
    where Signed: SignedInteger, Unsigned: UnsignedInteger {
        let ls: Signed = value << 1
        let rs: Signed = value >> (value.bitWidth - 1)
        return Unsigned(rs ^ ls)
    }
    
    @inlinable
    static func decode<Unsigned, Signed>(_ value: Unsigned) -> Signed
    where Unsigned: UnsignedInteger, Signed: SignedInteger {
        let ls: Signed = -Signed(value & 1)
        let rs: Signed = Signed(value >> 1)
        return Signed(ls ^ rs)
    }
}

extension Int8 {
    
    func _zigzagEncode() -> UInt8 {
        _ZigZag.encode(self)
    }
}


extension Int16 {
    
    func _zigzagEncode() -> UInt16 {
        _ZigZag.encode(self)
    }
}

extension Int32 {
    
    func _zigzagEncode() -> UInt32 {
        _ZigZag.encode(self)
    }
}

extension Int64 {
    
    func _zigzagEncode() -> UInt64 {
        _ZigZag.encode(self)
    }
}


extension UInt8 {
    
    func _zigzagDecode() -> Int8 {
        _ZigZag.decode(self)
    }
}

extension UInt16 {
    
    func zigzagDecode() -> Int16 {
        _ZigZag.decode(self)
    }
}

extension UInt32 {
    
    func _zigzagDecode() -> Int32 {
        _ZigZag.decode(self)
    }
}

extension UInt64 {
    
    func _zigzagDecode() -> Int64 {
        _ZigZag.decode(self)
    }
}
