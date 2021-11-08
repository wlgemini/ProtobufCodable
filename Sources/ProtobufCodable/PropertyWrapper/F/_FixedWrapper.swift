
@propertyWrapper
public final class _FixedWrapper<S: ScalarType> {
    
    public let fieldNumber: Swift.UInt32
    
    public var rawValue: S.T?
    
    public var wrappedValue: S.T {
        get { self.rawValue ?? S.default }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: Swift.UInt32) {
        self.fieldNumber = fieldNumber
    }
}
