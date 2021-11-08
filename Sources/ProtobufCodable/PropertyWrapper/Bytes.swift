
/// May contain any arbitrary sequence of bytes no longer than 2^32.
@propertyWrapper
final class Bytes {
    
    public let fieldNumber: Swift.UInt32
    
    public var rawValue: [Swift.UInt8]?
    
    public var wrappedValue: [Swift.UInt8] {
        get { self.rawValue ?? [] }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: Swift.UInt32) {
        self.fieldNumber = fieldNumber
    }
}


extension Bytes: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        #warning("Not impl")
    }
}
