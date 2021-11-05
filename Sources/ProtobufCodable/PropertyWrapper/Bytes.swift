
/// May contain any arbitrary sequence of bytes no longer than 2^32.
@propertyWrapper
final class Bytes {
    
    public let fieldNumber: UInt32
    
    public var rawValue: [Swift.UInt8]?
    
    public var wrappedValue: [Swift.UInt8] {
        get { self.rawValue ?? [] }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
