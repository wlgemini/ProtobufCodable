import Foundation


extension Singular {
    
    /// Uses variable-length encoding.
    @propertyWrapper
    public final class UInt32 {
        
        public let fieldNumber: Swift.UInt32
        
        public internal(set) var rawValue: Swift.UInt32?
        
        public var wrappedValue: Swift.UInt32 {
            get { self.rawValue ?? 0 }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.UInt32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapVarint.removeValue(forKey: self.fieldNumber) else { return }
        self.rawValue = Swift.UInt32(truncatingIfNeeded: bit64)
    }
}
