
///// a Protobuf Key
//protocol KeyProtocol {
//
//    var key: Key { get }
//}


/// a Varint Key
///
/// Each key in the streamed message is a varint with
/// the value `(field_number << 3) | wire_type` – in other words,
/// the last three bits of the number store the wire type.
struct _Key {
    
    /// UInt32 can represent enough field number, but we will use a varint form to encode it.
    ///
    /// - Field numbers in the range `1` through `15` take **one byte** to encode, including the field number and the field's type.
    /// - Field numbers in the range `16` through `2047` take **two bytes**.
    /// - The largest field numbers is `2^29 - 1`
    /// - The smallest field number is `1`
    /// - Cannot use the numbers `19000` through `19999` (`FieldDescriptor::kFirstReservedNumber` through `FieldDescriptor::kLastReservedNumber`), as they are reserved for the Protocol Buffers implementation
    ///
    let fieldNumber: UInt32
    let wireType: _WireType

    init(rawValue: UInt32) {
        let wireRaw = UInt8(rawValue & _WireType.bitMask)
        self.wireType = _WireType(rawValue: wireRaw) ?? .unknow
        self.fieldNumber = rawValue >> _WireType.bitMaskCount
    }
    
    init(fieldNumber: UInt32, wireType: _WireType) {
        self.fieldNumber = fieldNumber
        self.wireType = wireType
    }
}

extension _Key: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.fieldNumber)
    }
}
