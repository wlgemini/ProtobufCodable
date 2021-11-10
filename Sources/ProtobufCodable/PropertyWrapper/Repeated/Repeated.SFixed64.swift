import Foundation


/// Always eight bytes.
extension Repeated {
    
    @propertyWrapper
    public final class SFixed64 {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.Int64]?
        
        public var wrappedValue: [Swift.Int64] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.SFixed64: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited[self.fieldNumber]?.first else { return }
        let values = try _ByteBufferReader.readVarints(valueType: Swift.UInt64.self, range: range, data: reader.data)
        self.rawValue = values.map { _Integer.zigZagDecode($0) }
    }
}
