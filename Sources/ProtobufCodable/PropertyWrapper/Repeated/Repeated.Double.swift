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
//        guard let bits = reader.mapBit64[self.fieldNumber] else { return }
//        self.rawValue = Swift.Double(bitPattern: bits)
    }
}
