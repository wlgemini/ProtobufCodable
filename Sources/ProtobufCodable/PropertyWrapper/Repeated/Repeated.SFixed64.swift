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
//        guard let bits = reader.mapBit64[self.fieldNumber] else { return }
//        self.rawValue = _Integer.zigZagDecode(bits)
    }
}
