import Foundation


extension Singular {
    
    /// Always eight bytes.
    ///
    /// More efficient than `uint64` if values are often greater than 2^56.
    @propertyWrapper
    public final class Fixed64 {
        
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


extension Singular.Fixed64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let bit64 = reader.mapBit64.removeValue(forKey: self.fieldNumber) else { return }
        self.rawValue = bit64
    }
}
