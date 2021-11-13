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
        guard let range = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber)?.first else { return }
        let bit32s = try _ByteBufferReader.readVarints(valueType: Swift.UInt32.self, range: range, data: reader.data)
        self.rawValue = bit32s.map { _Integer.zigZagDecoded($0) }
    }
}
