
/// a Protobuf Key
protocol KeyProtocol {
    
    var key: Key { get }
}


/// a Varint Key
///
/// Each key in the streamed message is a varint with
/// the value `(field_number << 3) | wire_type` – in other words,
/// the last three bits of the number store the wire type.
struct Key {
    
    /// UInt32 can represent enough field number, but we will use a varint form to encode it.
    ///
    /// - Field numbers in the range `1` through `15` take **one byte** to encode, including the field number and the field's type.
    /// - Field numbers in the range `16` through `2047` take **two bytes**.
    /// - The largest field numbers is `2^29 - 1`
    /// - The smallest field number is `1`
    /// - Cannot use the numbers `19000` through `19999` (`FieldDescriptor::kFirstReservedNumber` through `FieldDescriptor::kLastReservedNumber`), as they are reserved for the Protocol Buffers implementation
    ///
    var fieldNumber: UInt32 { fatalError() }
    var wireType: WireType { fatalError() }
    
    let rawValue: UnsafeMutablePointer<UInt8>
    
    init(rawValue: UnsafeMutablePointer<UInt8>) {
        fatalError()
    }
}


/// Wire Type
enum WireType: UInt8 {
    
    /// Use for: int32, int64, uint32, uint64, sint32, sint64, bool, enum
    ///
    /// The values are stored in little-endian byte order.
    ///
    case varint = 0
    
    /// Use for: fixed64, sfixed64, double
    ///
    /// The values are stored in little-endian byte order.
    ///
    /// double and fixed64 have wire type 1, which tells the parser to expect a fixed 64-bit lump of data.
    case bit64 = 1
    
    /// Use for: string, bytes, embedded messages, packed repeated fields
    ///
    /// A wire type of 2 (length-delimited) means that the value is a varint encoded length followed by the specified number of bytes of data.
    ///
    /// [Varint Key][Varint Length][Bytes]
    ///
    /// - `Bytes`: `[UInt8]`, using raw bytes order.
    /// - `String` `String`, are encoded to `Bytes` using `.utf8` in `little-endian` bytes order. (which is `String.utf8` encoding default behaviour)
    /// - `Embedded message`: `Model` are encoded it's key-value pairs to `Bytes` without using `startGroup`/`endGroup` barrier.
    /// - `Packed repeated fields`: marked as `repeated`, it's just an `Array<Type>`. (In `proto3`, `repeated` fields of scalar numeric types use packed encoding by default.)
    ///
    case lengthDelimited = 2
    
    /// Use for: groups (deprecated)
    case startGroup = 3
    
    /// Use for: groups (deprecated)
    case endGroup = 4
    
    /// Use for: fixed32, sfixed32, float
    ///
    /// The values are stored in little-endian byte order.
    ///
    /// float and fixed32 have wire type 5, which tells it to expect 32 bits.
    case bit32 = 5
}
