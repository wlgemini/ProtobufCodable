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
        // clean data
        self._clean()
        
        // copy data to buffer
        let byteBufferReader = try _ByteBufferReader(from: data)
        self._byteBufferReader = byteBufferReader
        
        // read buffer
        try self._read(buffer: byteBufferReader)
        
        // decode
        let value = try T._decode(from: self)
        
        return value
    }
    
    deinit {
        self._clean()
    }
    
    // MARK: Internal
    var _byteBufferReader: _ByteBufferReader?
    var _mapVarint: [Key: Range<Int>] = [:]
    var _mapBit32: [Key: (Range<Int>, UInt32)] = [:]
    var _mapBit64: [Key: (Range<Int>, UInt64)] = [:]
    var _mapLengthDelimited: [Key: Range<Int>] = [:]
    
}

extension ProtobufDecoder {
    
    private func _read(buffer: _ByteBufferReader) throws {
        while buffer.index < buffer.count {
            // keyVarintDecode
            let (_, keyIsTruncating, keyValue) = try buffer.readVarint(UInt32.self)
            if keyIsTruncating {
                // must not truncating `key`
                throw ProtobufDeccodingError.corruptedData("varint decode: `key` truncated")
            }
            
            // key
            let key = Key(rawValue: keyValue)
            
            // key.wireType
            switch key.wireType {
            case .varint:
                let payloadByteRange = try buffer.skipVarint()
                self._mapVarint[key] = payloadByteRange
                
            case .bit32:
                self._mapBit32[key] = try buffer.readFixedWidthInteger(UInt32.self)
                
            case .bit64:
                self._mapBit64[key] = try buffer.readFixedWidthInteger(UInt64.self)
                
            case .lengthDelimited:
                let (_, lengthDelimitedIsTruncating, lengthDelimitedValue) = try buffer.readVarint(UInt32.self)
                if lengthDelimitedIsTruncating {
                    throw ProtobufDeccodingError.corruptedData("varint decode: `lengthDelimited.length` truncated")
                }
                
                let lengthDelimitedCount = Int(lengthDelimitedValue)
                if lengthDelimitedCount <= 0 {
                    throw ProtobufDeccodingError.corruptedData("varint decode: `lengthDelimited.length` is 0")
                }
                
                let lengthDelimitedByteRange = try buffer.skipBytes(count: lengthDelimitedCount)
                self._mapLengthDelimited[key] = lengthDelimitedByteRange
                
            case .unknow:
                throw ProtobufDeccodingError.unknowWireType
            }
        }
    }
    
    private func _clean() {
        self._mapVarint.removeAll()
        self._mapBit64.removeAll()
        self._mapLengthDelimited.removeAll()
        self._mapBit32.removeAll()
        self._byteBufferReader = nil
    }
}
