import Foundation


extension Repeated {
    
    @propertyWrapper
    public final class Float {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.Float]?
        
        public var wrappedValue: [Swift.Float] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}

extension Repeated.Float: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        guard let range = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber)?.first else { return }
        let bit32s = try _ByteBufferReader.readFixedWidthIntegers(valueType: Swift.UInt32.self, range: range, data: reader.data)
        self.rawValue = bit32s.map { Swift.Float(bitPattern: $0) }
    }
}
