
import Foundation


public final class ProtobufEncoder {
    
    public init() {}
    
    public func encode<T>(_ value: T) throws -> Data
    where T : ProtobufEncodable {
        let container = _ProtobufEncodingContainer()
        try value._encode(to: container)
        let data = Data(buffer: container.dataMutableBufferPointer)
        return data
    }
}
