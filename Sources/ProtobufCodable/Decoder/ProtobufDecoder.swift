import Foundation

/*
 用状态机来逐个解析property
 由于LengthDelimited类型会有Model嵌套，并且可能嵌套层次会很深，
 预解析并不能很简单处理Model嵌套问题
 所以，使用逐个property解析的方式来处理。
 这里使用状态机来实现，逻辑会比较简单。
 同时，要避免使用递归，应该使用循环。
 
 > 优点，不需要创建很多map，减少了memory alloc。
 */
public final class ProtobufDecoder {

    public init() {}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T
    where T : ProtobufDecodable {
        
        // read data
        let byteBufferReader = try _ByteBufferReader(from: data, in: 0 ..< data.count)
        
        // decode
        let value = try T._decode(from: byteBufferReader)
        
        return value
    }
}
