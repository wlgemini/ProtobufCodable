import Foundation


final class ProtobufDecoder {

    init() {}
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T
    where T : ProtobufDecodable {
        let container = ProtobufDecodingContainer(data: data)
        let instance = try T(from: container)
        self._container = container
        return instance
    }
    
    private var _container: ProtobufDecodingContainer?
}
