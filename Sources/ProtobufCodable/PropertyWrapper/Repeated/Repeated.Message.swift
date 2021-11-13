import Foundation


extension Repeated {
    
    @propertyWrapper
    public final class Message<T: ProtobufCodable> {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [T]?
        
        public var wrappedValue: [T] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.Message: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let ranges = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber) else { return }
        var models: [T] = []
        for range in ranges {
            let rangeReader = try _ByteBufferReader(from: reader.data, in: range)
            let model = try T._decode(from: rangeReader)
            models.append(model)
        }
        self.rawValue = models
    }
}
