
/// Always four bytes.
@propertyWrapper
final class SFixed32 {
    
    public let fieldNumber: Swift.UInt32
    
    public var rawValue: Swift.Int32?
    
    public var wrappedValue: Swift.Int32 {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: Swift.UInt32) {
        self.fieldNumber = fieldNumber
    }
}


extension SFixed32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bits = reader.mapBit32[self.fieldNumber] else { return }
        self.rawValue = _Integer.zigZagDecode(bits)
    }
}
