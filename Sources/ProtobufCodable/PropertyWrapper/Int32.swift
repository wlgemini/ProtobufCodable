
/// Uses variable-length encoding.
///
/// Inefficient for encoding negative numbers – if your field is likely to have negative values, use `sint32` instead.
@propertyWrapper
final class Int32 {
    
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
