
/// Uses variable-length encoding.
///
/// Inefficient for encoding negative numbers – if your field is likely to have negative values, use `sint64` instead.
@propertyWrapper
final class Int64 {
    
    public let fieldNumber: UInt32
    
    public var rawValue: Swift.Int64?
    
    public var wrappedValue: Swift.Int64 {
        get { self.rawValue ?? 0 }
        set { self.rawValue = newValue }
    }
    
    public init(_ fieldNumber: UInt32) {
        self.fieldNumber = fieldNumber
    }
}
