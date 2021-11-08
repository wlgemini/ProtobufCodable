
/// Because of `_ProtobufDecodingKey` is `class`,
/// any `ProtobufDecodable` type should use `class` for performance.
/// the *BEST* use case is mark `final` to `ProtobufDecodable` `class`.
public protocol ProtobufDecodable: Decodable, AnyObject {

    init()
}


extension ProtobufDecodable {
    
    static func _decode(from reader: _ByteBufferReader) throws -> Self {
        let value = Self.init()
        let mirror = Swift.Mirror(reflecting: value)
        for child in mirror.children {
            guard let decodingKey = child.value as? _DecodingKey else { continue }
            try decodingKey.decode(from: reader)
        }
        return value
    }
}
