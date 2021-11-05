
@propertyWrapper
public final class Repeated<S: ScalarType> {
    
    public let fieldNumber: UInt32
    
    public var rawValue: [S.T]?
    
    public var wrappedValue: [S.T] {
        get { self.rawValue ?? [] }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}

