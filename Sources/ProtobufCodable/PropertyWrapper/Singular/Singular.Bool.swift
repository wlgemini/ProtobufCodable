import Foundation


extension Singular {
    
    @propertyWrapper
    public final class Bool {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: Swift.Bool?
        
        public var wrappedValue: Swift.Bool {
            get { self.rawValue ?? false }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.Bool: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bits = reader.mapVarint[self.fieldNumber] else { return }
        self.rawValue = _Integer.bit(bits, at: 0)
    }
}
