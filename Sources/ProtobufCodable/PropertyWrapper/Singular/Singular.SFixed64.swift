import Foundation


extension Singular {
    
    /// Always eight bytes.
    @propertyWrapper
    public final class SFixed64 {
        
        public let fieldNumber: Swift.UInt32
        
        public internal(set) var rawValue: Swift.Int64?
        
        public var wrappedValue: Swift.Int64 {
            get { self.rawValue ?? 0 }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.SFixed64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapBit64.removeValue(forKey: self.fieldNumber) else { return }
        self.rawValue = Swift.Int64(bitPattern: bit64)
    }
}
