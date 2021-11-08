

/// Wire Type
public enum WireType: Swift.UInt8 {
    
    /// Use for: int32, int64, uint32, uint64, sint32, sint64, bool, enum
    ///
    /// The values are stored in little-endian byte order.
    ///
    /// 0b: `000`
    ///
    case varint = 0
    
    /// Use for: fixed32, sfixed32, float
    ///
    /// The values are stored in little-endian byte order.
    ///
    /// float and fixed32 have wire type 5, which tells it to expect 32 bits.
    ///
    /// 0b: `101`
    case bit32 = 5
    
    /// Use for: fixed64, sfixed64, double
    ///
    /// The values are stored in little-endian byte order.
    ///
    /// double and fixed64 have wire type 1, which tells the parser to expect a fixed 64-bit lump of data.
    ///
    /// 0b: `001`
    ///
    case bit64 = 1
    
    /// Use for: string, bytes, embedded messages, packed repeated fields
    ///
    /// A wire type of 2 (length-delimited) means that the value is a varint encoded length followed by the specified number of bytes of data.
    ///
    /// ```
    /// <Length-delimited key><Length><Bytes|String|Model|Packed Repeated Scalar Value>
    /// ```
    ///
    /// - `Bytes`: `[UInt8]`, using raw bytes order.
    /// - `String` `String`, are encoded to `Bytes` using `.utf8` in `little-endian` bytes order. (which is `String.utf8` encoding default behaviour)
    /// - `Model`: `Model` are encoded it's key-value pairs to `Bytes`.
    ///     * For `repeated Model`, same `<length-delimited key>` will repeat zero or more times while in decoding data.
    /// - `Packed Repeated Scalar Value`: marked as `repeated`, it's just an `Array<Scalar Value>`. (In `proto3`, `repeated` fields of scalar numeric types use `packed` encoding by default, A `packed repeated` field containing zero elements does not appear in the encoded message.)
    ///
    ///
    /// 0b: `010`
    ///
    case lengthDelimited = 2
    
    /// Use for: unknow type, or ⚠️ proto2's `.startGroup = 3`, `.endGroup = 4`
    ///
    case unknow = 0b0000_0111
}


extension WireType {
    
    static var bitMask: Swift.UInt32 { 0b0000_0111 }
    
    static var bitMaskCount: Swift.UInt32 { 3 }
}
