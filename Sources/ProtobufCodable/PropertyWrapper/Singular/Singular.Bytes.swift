import Foundation

extension Singular {
    
    /// May contain any arbitrary sequence of bytes no longer than 2^32.
    @propertyWrapper
    public final class Bytes {
        
        public let fieldNumber: Swift.UInt32
        
        public internal(set) var rawValue: Data?
        
        public var wrappedValue: Data {
            get { self.rawValue ?? Data() }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.Bytes: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber)?.first else { return }
        self.rawValue = reader.data[range]
    }
}
