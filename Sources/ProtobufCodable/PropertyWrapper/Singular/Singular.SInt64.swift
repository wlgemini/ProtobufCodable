import Foundation


extension Singular {
    
    /// Uses variable-length encoding.
    ///
    /// Signed int value. These more efficiently encode negative numbers than regular `int64`s.
    @propertyWrapper
    public final class SInt64 {
        
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


extension Singular.SInt64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapVarint.removeValue(forKey: self.fieldNumber) else { return }
        self.rawValue = _Integer.zigZagDecoded(bit64)
    }
}
