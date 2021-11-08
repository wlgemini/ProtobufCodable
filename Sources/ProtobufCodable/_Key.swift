
/// a Varint Key
///
/// Each key in the streamed message is a varint with
/// the value `(field_number << 3) | wire_type` – in other words,
/// the last three bits of the number store the wire type.
public struct Key {
    
    /// UInt32 can represent enough field number, but we will use a varint form to encode it.
    ///
    /// - Field numbers in the range `1` through `15` take **one byte** to encode, including the field number and the field's type.
    /// - Field numbers in the range `16` through `2047` take **two bytes**.
    /// - The largest field numbers is `2^29 - 1`
    /// - The smallest field number is `1`
    /// - Cannot use the numbers `19000` through `19999` (`FieldDescriptor::kFirstReservedNumber` through `FieldDescriptor::kLastReservedNumber`), as they are reserved for the Protocol Buffers implementation
    ///
    public let fieldNumber: Swift.UInt32
    public let wireType: WireType
    public let rawValue: Swift.UInt32

    public init(rawValue: Swift.UInt32) {
        let wireRaw = Swift.UInt8(rawValue & WireType.bitMask)
        self.wireType = WireType(rawValue: wireRaw) ?? .unknow
        self.fieldNumber = rawValue >> WireType.bitMaskCount
        self.rawValue = rawValue
    }
    
    public init(fieldNumber: Swift.UInt32, wireType: WireType) {
        self.fieldNumber = fieldNumber
        self.wireType = wireType
        self.rawValue = (fieldNumber << WireType.bitMaskCount) | Swift.UInt32(wireType.rawValue)
    }
}

extension Key: Swift.Hashable {
    
    public func hash(into hasher: inout Swift.Hasher) {
        hasher.combine(self.fieldNumber)
    }
}
