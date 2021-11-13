import Foundation


/// Uses variable-length encoding.
extension Repeated {
    
    @propertyWrapper
    public final class UInt64 {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.UInt64]?
        
        public var wrappedValue: [Swift.UInt64] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.UInt64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber)?.first else { return }
        let bit64s = try _ByteBufferReader.readVarints(valueType: Swift.UInt64.self, range: range, data: reader.data)
        self.rawValue = bit64s.map { Swift.UInt64(truncatingIfNeeded: $0) }
    }
}
