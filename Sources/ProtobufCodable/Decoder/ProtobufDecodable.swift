

public protocol ProtobufDecodable: Decodable {

    init()
}


extension ProtobufDecodable {
    
    init(from container: ProtobufDecodingContainer) throws {
        self.init()
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children {
            guard let decodingKey = value as? ProtobufDecodingKey else { continue }
            decodingKey.decode(from: container)
        }
    }
}
