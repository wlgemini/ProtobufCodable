
/// Each key in the streamed message is a varint with the value (field_number << 3) | wire_type – in other words, the last three bits of the number store the wire type.
protocol KeyProtocol {
    
    var fieldNumber: UInt { get }
    
    var wireType: Wire { get }
}
