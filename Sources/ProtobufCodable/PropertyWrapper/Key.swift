
/*
 Synthesis for Encodable, Decodable, Hashable, and Equatable use the backing storage property.
 This allows property wrapper types to determine their own serialization and equality behavior.
 For Encodable and Decodable, the name used for keyed archiving is that of the original property declaration (without the _).
 */
@propertyWrapper
public struct Key<T> {
    
    public let fieldNumber: UInt
    
    public var wrappedValue: T
    
    public init(wrappedValue: T, _ fieldNumber: UInt) {
        self.fieldNumber = fieldNumber
        self.wrappedValue = wrappedValue
    }
}

extension Key: Decodable where T: Decodable {
    
}

extension Key: Encodable where T: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.fieldNumber, forKey: CodingKeys.fieldNumber)
        try container.encode(self.wrappedValue, forKey: CodingKeys.wrappedValue)
    }
}
