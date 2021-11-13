import Foundation


extension Singular {
    
    /// Uses variable-length encoding.
    ///
    /// Inefficient for encoding negative numbers – if your field is likely to have negative values, use `sint32` instead.
    @propertyWrapper
    public final class Int32 {
        
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


extension Singular.Int32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapVarint.removeValue(forKey: self.fieldNumber) else { return }
        let bit32 = Swift.UInt32(truncatingIfNeeded: bit64)
        self.rawValue = Swift.Int32(bitPattern: bit32)
    }
}
