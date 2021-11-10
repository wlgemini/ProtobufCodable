import Foundation


/// Always eight bytes.
///
/// More efficient than `uint64` if values are often greater than 2^56.
extension Repeated {
    
    @propertyWrapper
    public final class Fixed64 {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.UInt64]?
        
        public var wrappedValue: [Swift.UInt64] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.Fixed64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited[self.fieldNumber]?.first else { return }
        self.rawValue = try _ByteBufferReader.readFixedWidthIntegers(valueType: Swift.UInt64.self, range: range, data: reader.data)
    }
}
