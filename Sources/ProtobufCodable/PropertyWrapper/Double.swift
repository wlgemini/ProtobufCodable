
@propertyWrapper
final class Double {
    
    public let fieldNumber: UInt32
    
    public var rawValue: Swift.Double?
    
    public var wrappedValue: Swift.Double {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
