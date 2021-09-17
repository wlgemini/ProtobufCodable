
@propertyWrapper
public final class Varint<T: VarintValue> {
    
    public init(_ fieldNumber: UInt32) {
        self._fieldNumber = fieldNumber
    }
    
    public var wrappedValue: T {
        get { self._value ?? T.default }
        set { self._value = newValue }
    }
    
    // MARK: Private
    private let _fieldNumber: UInt32
    private var _value: T?
}

extension Varint: _EncodingKey, _DecodingKey {
    
    func encode(to encoder: ProtobufEncoder) throws {
        
    }
    
    func decode(from decoder: ProtobufDecoder) throws {
        
    }
}

// MARK: - VarintValue
public protocol VarintValue {
    
    static var `default`: Self { get }
    
    var varint: UnsafeMutableBufferPointer<Byte> { get }
}

//
//extension Swift.Int32: VarintValue {
//    
//    public static var `default`: Self { 0 }
//    
//    public var varint: UnsafeMutableBufferPointer<Byte> {
//        _Varint.encode(self.littleEndian._zigzagEncode())
//    }
//}
//
//extension Swift.Int64: VarintValue {
//    
//    public static var `default`: Self { 0 }
//    
//    public var varint: UnsafeMutableBufferPointer<Byte> {
//        _Varint.encode(self.littleEndian._zigzagEncode())
//    }
//}
//
//extension Swift.UInt32: VarintValue {
//    
//    public static var `default`: Self { 0 }
//    
//    public var varint: UnsafeMutableBufferPointer<Byte> {
//        _Varint.encode(self.littleEndian)
//    }
//}
//
//extension Swift.UInt64: VarintValue {
//    
//    public static var `default`: Self { 0 }
//    
//    public var varint: UnsafeMutableBufferPointer<Byte> {
//        _Varint.encode(self.littleEndian)
//    }
//}
