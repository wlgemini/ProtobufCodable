
/// Always four bytes.
@propertyWrapper
final class SFixed32 {
    
    public let fieldNumber: UInt32
    
    public var rawValue: Swift.Int32?
    
    public var wrappedValue: Swift.Int32 {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
