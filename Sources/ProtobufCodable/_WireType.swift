

/// Wire Type
public enum WireType: UInt8 {
    
    /// Use for: int32, int64, uint32, uint64, sint32, sint64, bool, enum
    ///
    /// The values are stored in little-endian byte order.
    ///
    case varint = 0 /* 0b0000 */
    
    /// Use for: fixed32, sfixed32, float
    ///
    /// The values are stored in little-endian byte order.
    ///
    /// float and fixed32 have wire type 5, which tells it to expect 32 bits.
    case bit32 = 5 /* 0b0101 */
    
    /// Use for: fixed64, sfixed64, double
    ///
    /// The values are stored in little-endian byte order.
    ///
    /// double and fixed64 have wire type 1, which tells the parser to expect a fixed 64-bit lump of data.
    case bit64 = 1 /* 0b0001 */
    
    /// Use for: string, bytes, embedded messages, packed repeated fields
    ///
    /// A wire type of 2 (length-delimited) means that the value is a varint encoded length followed by the specified number of bytes of data.
    ///
    /// <Varint Key><Varint Length><`Bytes`|`String`|`Embedded message`|`Packed repeated fields`>
    ///
    /// - `Bytes`: `[UInt8]`, using raw bytes order.
    /// - `String` `String`, are encoded to `Bytes` using `.utf8` in `little-endian` bytes order. (which is `String.utf8` encoding default behaviour)
    /// - `Embedded message`: `Model` are encoded it's key-value pairs to `Bytes` without using `startGroup`/`endGroup` barrier.
    /// - `Packed repeated fields`: marked as `repeated`, it's just an `Array<Type>`. (In `proto3`, `repeated` fields of scalar numeric types use `packed` encoding by default, A `packed repeated` field containing zero elements does not appear in the encoded message.)
    ///
    case lengthDelimited = 2 /* 0b0010 */
    
    /// Use for: unknow type, or ⚠️ proto2's `.startGroup = 3`, `.endGroup = 4`
    ///
    case unknow = 0b0000_0111
}


extension WireType {
    
    static var bitMask: UInt32 { 0b0000_0111 }
    
    static var bitMaskCount: UInt32 { 3 }
}
