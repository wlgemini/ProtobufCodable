import Foundation


/// Uses variable-length encoding.
///
/// Inefficient for encoding negative numbers – if your field is likely to have negative values, use `sint32` instead.
extension Repeated {
    
    @propertyWrapper
    public final class Int32 {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.Int32]?
        
        public var wrappedValue: [Swift.Int32] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.Int32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited[self.fieldNumber]?.first else { return }
        let values = try _ByteBufferReader.readVarints(valueType: Swift.UInt32.self, range: range, data: reader.data)
        self.rawValue = values.map { Swift.Int32(bitPattern: $0) }
    }
}
