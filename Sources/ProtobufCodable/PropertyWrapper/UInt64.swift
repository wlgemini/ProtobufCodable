
/// Uses variable-length encoding.
@propertyWrapper
final class UInt64 {
    
    public let fieldNumber: UInt32
    
    public var rawValue: Swift.UInt64?
    
    public var wrappedValue: Swift.UInt64 {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}


extension UInt64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bits = reader.mapVarint[self.fieldNumber] else { return }
        self.rawValue = bits
    }
}
