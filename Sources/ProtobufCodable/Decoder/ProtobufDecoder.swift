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
        try self._decode(buffer: byteBuffer)
        
        // save
        self._byteBuffer = byteBuffer
        
        // decode
        let value = try T._decode(from: self)
        
        return value
    }
    
    deinit {
        self._deinit()
    }
    
    // MARK: Private
    private var _byteBuffer: _ByteBuffer?
    
    private var _mapVarint: [_Key: Range<Int>] = [:]
    private var _mapBit64: [_Key: (Range<Int>, UInt64)] = [:]
    private var _mapLengthDelimited: [_Key: Range<Int>] = [:]
    private var _mapBit32: [_Key: (Range<Int>, UInt32)] = [:]
    
    private func _decode(buffer: _ByteBuffer) throws {
        while buffer.index < buffer.count {
            // keyVarintDecode
            let (_, keyIsTruncating, keyValue) = try buffer.readVarint(UInt32.self)
            if keyIsTruncating {
                // must not truncating `key`
                throw ProtobufDeccodingError.corruptedData("varint decode: `key` truncated")
            }
            
            // key
            let key = _Key(rawValue: keyValue)
            
            // key.wireType
            switch key.wireType {
            case .varint:
                let payloadByteRange = try buffer.readVarint()
                self._mapVarint[key] = payloadByteRange
                
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
                
                let lengthDelimitedByteRange = buffer.readBytes(lengthDelimitedCount)
                self._mapLengthDelimited[key] = lengthDelimitedByteRange
                
            case .bit32:
                self._mapBit32[key] = try buffer.readFixedWidthInteger(UInt32.self)
                
            case .unknow:
                #warning("throw ProtobufDeccodingError.unknowWireType 就不能向下兼容了，怎么办？")
                throw ProtobufDeccodingError.unknowWireType
            }
        }
    }
    
    private func _deinit() {
        self._mapVarint.removeAll()
        self._mapBit64.removeAll()
        self._mapLengthDelimited.removeAll()
        self._mapBit32.removeAll()
        
        self._byteBuffer = nil
    }
}
