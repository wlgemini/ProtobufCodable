import Foundation


extension Singular {
    
    @propertyWrapper
    public final class Bool {
        
        public let fieldNumber: Swift.UInt32
        
        public internal(set) var rawValue: Swift.Bool?
        
        public var wrappedValue: Swift.Bool {
            get { self.rawValue ?? false }
            set { self.rawValue = newValue }
        }
        
        public init(_ fieldNumber: Swift.UInt32) {
            self.fieldNumber = fieldNumber
        }
    }
}


extension Singular.Bool: _DecodingKey {
    
    func decode(from reader: _ByteBufferReader) throws {
        /*
         Because of COW, Dictionary may make a copy of itself before remove any Element.
         That's why the complexity of removeValue(forKey:) is O(n).
         So, keep Dictionary only have 1 reference to keep away from COW.
         */
        guard let bits = reader.mapVarint.removeValue(forKey: self.fieldNumber) else { return }
        self.rawValue = _Integer.bit(bits, at: 0)
    }
}
