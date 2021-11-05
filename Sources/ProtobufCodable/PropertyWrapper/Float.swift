
@propertyWrapper
final class Float {
    
    public let fieldNumber: UInt32
    
    public var rawValue: Swift.Float?
    
    public var wrappedValue: Swift.Float {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
