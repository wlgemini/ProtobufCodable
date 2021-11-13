import Foundation


extension Singular {
    
    /// Uses variable-length encoding.
    ///
    /// Signed int value. These more efficiently encode negative numbers than regular `int32`s.
    @propertyWrapper
    public final class SInt32 {
        
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


extension Singular.SInt32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapVarint.removeValue(forKey: self.fieldNumber) else { return }
        let bit32 = Swift.UInt32(truncatingIfNeeded: bit64)
        self.rawValue = _Integer.zigZagDecoded(bit32)
    }
}
