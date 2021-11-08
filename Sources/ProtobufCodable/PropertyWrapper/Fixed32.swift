
/// Always four bytes.
///
/// More efficient than `uint32` if values are often greater than 2^28.
@propertyWrapper
final class Fixed32 {
    
    public let fieldNumber: Swift.UInt32
    
    public var rawValue: Swift.UInt32?
    
    public var wrappedValue: Swift.UInt32 {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: Swift.UInt32) {
        self.fieldNumber = fieldNumber
    }
}


extension Fixed32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bits = reader.mapBit32[self.fieldNumber] else { return }
        self.rawValue = bits
    }
}
