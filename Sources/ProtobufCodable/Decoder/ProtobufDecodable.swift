

public protocol ProtobufDecodable: Decodable {

    init()
}


extension ProtobufDecodable {
    
    static func _decode(from container: _ProtobufDecodingContainer) throws -> Self {
        let value = Self.init()
        let mirror = Mirror(reflecting: value)
        for child in mirror.children {
            guard let decodingKey = child.value as? _ProtobufDecodingKey else { continue }
            try decodingKey.decode(from: container)
        }
        return value
    }
}
