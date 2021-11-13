import Foundation


extension Repeated {
    
    @propertyWrapper
    public final class Bool {
        
        public let fieldNumber: Swift.UInt32
        
        public var rawValue: [Swift.Bool]?
        
        public var wrappedValue: [Swift.Bool] {
            get { self.rawValue ?? [] }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Repeated.Bool: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        /*
         Because of COW, Dictionary may make a copy of itself before remove any Element.
         That's why the complexity of removeValue(forKey:) is O(n).
         So, keep Dictionary only have 1 reference to keep away from COW.
         */
        guard let range = reader.mapLengthDelimited.removeValue(forKey: self.fieldNumber)?.first else { return }
        self.rawValue = range.map { _Integer.bit(reader.data[$0], at: 0) }
    }
}
