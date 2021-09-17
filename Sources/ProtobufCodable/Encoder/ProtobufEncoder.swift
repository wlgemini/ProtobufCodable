
import Foundation


public final class ProtobufEncoder {
    
    public init() {}
    
    public func encode<T>(_ value: T) throws -> Data
    where T : ProtobufEncodable {
        try value._encode(to: self)
        let data = Data() //Data(buffer: container.dataMutableBufferPointer)
        return data
    }
}
