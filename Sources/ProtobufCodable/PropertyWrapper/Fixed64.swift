
/// Always eight bytes.
///
/// More efficient than `uint64` if values are often greater than 2^56.
@propertyWrapper
final class Fixed64 {
    
    public let fieldNumber: Swift.UInt32
    
    public var rawValue: Swift.UInt64?
    
    public var wrappedValue: Swift.UInt64 {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: Swift.UInt32) {
        self.fieldNumber = fieldNumber
    }
}


extension Fixed64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bits = reader.mapBit64[self.fieldNumber] else { return }
        self.rawValue = bits
    }
}
