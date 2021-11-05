
@propertyWrapper
final class Bool {
    
    public let fieldNumber: UInt32
    
    public var rawValue: Swift.Bool?
    
    public var wrappedValue: Swift.Bool {
        get { self.rawValue ?? false }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
