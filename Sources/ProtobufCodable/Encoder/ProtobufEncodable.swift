
public protocol ProtobufEncodable: Encodable {}


extension ProtobufEncodable {
    
    func _encode(to container: _ProtobufEncodingContainer) throws {
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let encodingKey = child.value as? _ProtobufEncodingKey else { continue }
            try encodingKey.encode(to: container)
        }
    }
}
