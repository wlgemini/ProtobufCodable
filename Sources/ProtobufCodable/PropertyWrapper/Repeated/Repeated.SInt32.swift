import Foundation


/// Uses variable-length encoding.
///
/// Signed int value. These more efficiently encode negative numbers than regular `int32`s.
extension Repeated {
    
    @propertyWrapper
    public final class SInt32 {
        
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


extension Repeated.SInt32: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
//        guard let bits = reader.mapVarint[self.fieldNumber] else { return }
//        let bit32 = Swift.UInt32.init(truncatingIfNeeded: bits)
//        self.rawValue = _Integer.zigZagDecode(bit32)
        
        guard let range = reader.mapLengthDelimited[self.fieldNumber]?.first else { return }
        let values = try _ByteBufferReader.readVarints(valueType: Swift.UInt32.self, range: range, data: reader.data)
        self.rawValue = values.map { _Integer.zigZagDecoded(bit32) }
    }
}
