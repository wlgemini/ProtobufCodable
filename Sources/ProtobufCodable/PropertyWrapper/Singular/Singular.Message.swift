import Foundation


extension Singular {
    
    @propertyWrapper
    public final class Message<T: ProtobufCodable> {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: T?
        
        public var wrappedValue: T {
            get { self.rawValue ?? T.init() }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.Message: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited[self.fieldNumber]?.first else { return }
        let rangeReader = try _ByteBufferReader(from: reader.data, in: range)
        self.rawValue = try T._decode(from: rangeReader)
    }
}
