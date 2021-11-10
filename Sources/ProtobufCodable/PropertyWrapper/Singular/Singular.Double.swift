import Foundation


extension Singular {
    
    @propertyWrapper
    public final class Double {
        
        public let fieldNumber: Swift.UInt32
        
        public internal(set) var rawValue: Swift.Double?
        
        public var wrappedValue: Swift.Double {
            get { self.rawValue ?? 0 }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.Double: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapBit64[self.fieldNumber] else { return }
        self.rawValue = Swift.Double(bitPattern: bit64)
    }
}
