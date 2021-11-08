
/// Uses variable-length encoding.
@propertyWrapper
final class UInt32 {
    
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


extension UInt32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bits = reader.mapVarint[self.fieldNumber] else { return }
        self.rawValue = Swift.UInt32.init(truncatingIfNeeded: bits)
    }
}
