
@propertyWrapper
public final class _VarintWrapper<S: ScalarType> {
    
    public let fieldNumber: UInt32
    
    public var rawValue: S.T?
    
    public var wrappedValue: S.T {
        get { self.rawValue ?? S.default }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
