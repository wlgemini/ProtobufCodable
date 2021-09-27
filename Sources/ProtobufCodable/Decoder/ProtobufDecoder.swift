import Foundation


public final class ProtobufDecoder {

    public init() {}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T
    where T : ProtobufDecodable {
        // deinit any heap data
        self._deinit()
        
        // copy data
        let byteBuffer = try _ByteBuffer(from: data)
        
        // map data
        let map = try self._decode(buffer: byteBuffer)
        
        // save
        self._byteBuffer = byteBuffer
        self._map = map
        
        // decode
        let value = try T._decode(from: self)
        
        return value
    }
    
    deinit {
        self._deinit()
    }
    
    // MARK: Private
    private var _byteBuffer: _ByteBuffer?
    private var _map: [_Key: Range<Int>]?
    
    private func _decode(buffer: _ByteBuffer) throws -> [_Key: Range<Int>] {
        var map: [_Key: Range<Int>] = [:]
        while buffer.index < buffer.count {
            // keyVarintDecode
            let (_, keyIsTruncating, keyValue) = try buffer.readVarint(UInt32.self)//_Varint.decode(dataBufferPointer, from: byteIndex)
            if keyIsTruncating {
                // must not truncating `key`
                throw ProtobufDeccodingError.corruptedData("varint decode: `key` truncated")
            }
            
            // key
            let key = _Key(rawValue: keyValue)
            
            // key.wireType
            switch key.wireType {
            case .varint:
                let payloadByteRange = try buffer.readVarintOne()
                map[key] = payloadByteRange
                
            case .bit64:
                let (payloadByteRange, _) = try buffer.readFixedWidthInteger(UInt64.self)
                map[key] = payloadByteRange
                
            case .lengthDelimited:
                let (_, lengthDelimitedIsTruncating, lengthDelimitedValue) = try buffer.readVarint(UInt32.self)
                if lengthDelimitedIsTruncating {
                    throw ProtobufDeccodingError.corruptedData("varint decode: `lengthDelimited.length` truncated")
                }
                
                let lengthDelimitedCount = Int(lengthDelimitedValue)
                if lengthDelimitedCount <= 0 {
                    throw ProtobufDeccodingError.corruptedData("varint decode: `lengthDelimited.length` is 0")
                }
                
                let lengthDelimitedByteRange = buffer.readBytes(lengthDelimitedCount)
                map[key] = lengthDelimitedByteRange
                
            case .bit32:
                let (payloadByteRange, _) = try buffer.readFixedWidthInteger(UInt32.self)
                map[key] = payloadByteRange
                
            case .unknow:
                throw ProtobufDeccodingError.unknowWireType
            }
        }
        
        return map
    }
    
    private func _deinit() {
        self._map = nil
        self._byteBuffer = nil
    }
}
