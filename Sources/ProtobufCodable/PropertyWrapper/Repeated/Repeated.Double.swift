import Foundation


extension Repeated {
    
    @propertyWrapper
    public final class Double {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.Double]?
        
        public var wrappedValue: [Swift.Double] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.Double: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited[self.fieldNumber]?.first else { return }
        let values = try _ByteBufferReader.readFixedWidthIntegers(valueType: Swift.UInt64.self, range: range, data: reader.data)
        self.rawValue = values.map { Swift.Double(bitPattern: $0) }
    }
}
