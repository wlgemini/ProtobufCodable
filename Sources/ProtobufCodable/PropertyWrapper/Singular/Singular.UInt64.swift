import Foundation


extension Singular {
    
    /// Uses variable-length encoding.
    @propertyWrapper
    public final class UInt64 {
        
        public let fieldNumber: Swift.UInt32
        
        public internal(set) var rawValue: Swift.UInt64?
        
        public var wrappedValue: Swift.UInt64 {
            get { self.rawValue ?? 0 }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.UInt64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapVarint.removeValue(forKey: self.fieldNumber) else { return }
        self.rawValue = bit64
    }
}
