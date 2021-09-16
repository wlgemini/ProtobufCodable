
/// Because of `_ProtobufEncodingKey` is `class`,
/// any `ProtobufEncodable` type should use `class` for performance.
/// the *BEST* use case is mark `final` to `ProtobufEncodable` `class`.
public protocol ProtobufEncodable: Encodable, AnyObject {}


extension ProtobufEncodable {
    
    func _encode(to container: _ProtobufEncodingContainer) throws {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let encodingKey = child.value as? _ProtobufEncodingKey else { continue }
            try encodingKey.encode(to: container)
        }
    }
}
