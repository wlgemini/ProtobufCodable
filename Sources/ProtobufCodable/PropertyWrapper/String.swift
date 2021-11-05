
/// A string must always contain UTF-8 encoded or 7-bit ASCII text, and cannot be longer than 2^32.
@propertyWrapper
final class String {
    
    public let fieldNumber: UInt32
    
    public var rawValue: Swift.String?
    
    public var wrappedValue: Swift.String {
        get { self.rawValue ?? "" }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
