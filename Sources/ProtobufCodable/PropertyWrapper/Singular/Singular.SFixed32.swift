import Foundation


extension Singular {
    
    /// Always four bytes.
    @propertyWrapper
    public final class SFixed32 {
        
        public let fieldNumber: Swift.UInt32
        
        public internal(set) var rawValue: Swift.Int32?
        
        public var wrappedValue: Swift.Int32 {
            get { self.rawValue ?? 0 }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.SFixed32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit32 = reader.mapBit32[self.fieldNumber] else { return }
        self.rawValue = Swift.Int32(bitPattern: bit32)
    }
}
