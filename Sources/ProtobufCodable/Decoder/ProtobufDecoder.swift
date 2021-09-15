import Foundation


public final class ProtobufDecoder {

    public init() {}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T
    where T : ProtobufDecodable {
        let container = _ProtobufDecodingContainer(data: data)
        let value = try T._decode(from: container)
        return value
    }
}
