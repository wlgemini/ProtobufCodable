import Foundation


/// Always four bytes.
///
/// More efficient than `uint32` if values are often greater than 2^28.
extension Repeated {
    
    @propertyWrapper
    public final class Fixed32 {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.UInt32]?
        
        public var wrappedValue: [Swift.UInt32] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.Fixed32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber)?.first else { return }
        self.rawValue = try _ByteBufferReader.readFixedWidthIntegers(valueType: Swift.UInt32.self, range: range, data: reader.data)
    }
}
