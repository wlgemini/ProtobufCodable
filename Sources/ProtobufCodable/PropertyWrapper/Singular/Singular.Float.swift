import Foundation


extension Singular {
    
    @propertyWrapper
    public final class Float {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: Swift.Float?
        
        public var wrappedValue: Swift.Float {
            get { self.rawValue ?? 0 }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.Float: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bits = reader.mapBit32[self.fieldNumber] else { return }
        self.rawValue = Swift.Float(bitPattern: bits)
    }
}
