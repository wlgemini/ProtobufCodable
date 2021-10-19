import Foundation


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
    var _mapVarint: [_Key: Range<Int>] = [:]
    var _mapBit32: [_Key: (Range<Int>, UInt32)] = [:]
    var _mapBit64: [_Key: (Range<Int>, UInt64)] = [:]
    var _mapLengthDelimited: [_Key: Range<Int>] = [:]
    
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
            let key = _Key(rawValue: keyValue)
            
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
