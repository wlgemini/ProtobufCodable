
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
