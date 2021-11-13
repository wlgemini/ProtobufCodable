import Foundation


/// Uses variable-length encoding.
extension Repeated {
    
    @propertyWrapper
    public final class UInt32 {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.UInt32]?
        
        public var wrappedValue: [Swift.UInt32] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.UInt32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber)?.first else { return }
        let bit32s = try _ByteBufferReader.readVarints(valueType: Swift.UInt32.self, range: range, data: reader.data)
        self.rawValue = bit32s.map { Swift.UInt32(truncatingIfNeeded: $0) }
    }
}
