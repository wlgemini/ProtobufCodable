
import Foundation


public final class ProtobufEncoder {
    
    public init() {}
    
    public func encode<T>(_ value: T) throws -> Data
    where T : ProtobufEncodable {
        #warning("只有叶子节点才有Size")
        // 收集叶子节点的Size
        try value._encode(to: self)
        let data = Data() //Data(buffer: container.dataMutableBufferPointer)
        return data
    }
    
    // MARK: Internal
    var _byteBufferReader: _ByteBufferReader?
    var _mapVarint: [_Key: Range<Int>] = [:]
    var _mapBit32: [_Key: (Range<Int>, UInt32)] = [:]
    var _mapBit64: [_Key: (Range<Int>, UInt64)] = [:]
    var _mapLengthDelimited: [_Key: Range<Int>] = [:]
}
