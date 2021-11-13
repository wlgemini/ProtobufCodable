import Foundation


extension Singular {
    
    /// Uses variable-length encoding.
    ///
    /// Inefficient for encoding negative numbers – if your field is likely to have negative values, use `sint64` instead.
    @propertyWrapper
    public final class Int64 {
        
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


extension Singular.Int64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapVarint.removeValue(forKey: self.fieldNumber) else { return }
        self.rawValue = Swift.Int64(bitPattern: bit64)
    }
}
