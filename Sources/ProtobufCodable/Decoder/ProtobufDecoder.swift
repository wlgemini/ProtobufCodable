import Foundation


public final class ProtobufDecoder {

    public init() {}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T
    where T : ProtobufDecodable {
        // deinit any heap data
        self._deinit()
        
        // copy data
        let dataMutableBufferPointer = try self._copy(data: data)
        
        // map data
        let map = try self._decode(dataMutableBufferPointer: dataMutableBufferPointer)
        
        // save
        self._dataMutableBufferPointer = dataMutableBufferPointer
        self._map = map
        
        // decode
        let value = try T._decode(from: self)
        
        return value
    }
    
    deinit {
        self._deinit()
    }
    
    // MARK: Private
    private var _dataMutableBufferPointer: UnsafeMutableBufferPointer<Byte>?
    private var _map: [_Key: ClosedRange<Int>]?
    
    private func _copy(data: Data) throws -> UnsafeMutableBufferPointer<Byte> {
        let dataMutableBufferPointer = UnsafeMutableBufferPointer<Byte>.allocate(capacity: data.count)
        dataMutableBufferPointer.initialize(repeating: 0)
        let copiedBytesCount = data.copyBytes(to: dataMutableBufferPointer)
        assert(copiedBytesCount == data.count)
        return dataMutableBufferPointer
    }
    
    private func _decode(dataMutableBufferPointer: UnsafeMutableBufferPointer<Byte>) throws -> [_Key: ClosedRange<Int>] {
        var map: [_Key: ClosedRange<Int>] = [:]
        let dataBufferPointer = UnsafeBufferPointer<Byte>(dataMutableBufferPointer)
        var byteIndex: Int = 0
        while byteIndex < dataBufferPointer.count {
            // keyVarintDecode
            let keyVarintDecode: (Int, Bool, UInt32) = _Varint.decode(dataBufferPointer, from: byteIndex)
            let keyDecodeByteCount = keyVarintDecode.0
            let keyIsTruncating = keyVarintDecode.1
            let keyRaw = keyVarintDecode.2
            if keyIsTruncating {
                // must not truncating `key`
                throw ProtobufDeccodingError.corruptedData("varint decode: `key` truncated")
            }
            
            // payload byte index
            let payloadByteIndex = byteIndex + keyDecodeByteCount
            
            // key
            let key = _Key(rawValue: keyRaw)
            
            // key.wireType
            switch key.wireType {
            case .varint:
                let payloadByteRange = _Varint.readOne(dataBufferPointer, from: payloadByteIndex)
                byteIndex = payloadByteIndex + payloadByteRange.count
                map[key] = payloadByteRange
                
            case .bit64:
                let payloadByteRange: ClosedRange = (payloadByteIndex + 0) ... (payloadByteIndex + 7)
                byteIndex = payloadByteIndex + 8
                map[key] = payloadByteRange
                
            case .lengthDelimited:
                let payloadVarintDecode: (Int, Bool, UInt32) = _Varint.decode(dataBufferPointer, from: payloadByteIndex)
                let payloadDecodeByteCount = payloadVarintDecode.0
                let payloadIsTruncating = payloadVarintDecode.1
                let payloadRaw = payloadVarintDecode.2
                assert(payloadIsTruncating == false)
                if payloadIsTruncating {
                    throw ProtobufDeccodingError.corruptedData("varint decode: `lengthDelimited.length` truncated")
                }
                
                let lengthDelimitedByteIndex = payloadByteIndex + payloadDecodeByteCount
                let lengthDelimitedCount = Int(payloadRaw)
                if lengthDelimitedCount <= 0 {
                    throw ProtobufDeccodingError.corruptedData("varint decode: `lengthDelimited.length` is 0")
                }
                
                let lengthDelimitedByteRange: ClosedRange = (lengthDelimitedByteIndex + 0) ... (lengthDelimitedByteIndex + lengthDelimitedCount - 1)
                
                byteIndex = lengthDelimitedByteIndex + lengthDelimitedByteRange.count
                map[key] = lengthDelimitedByteRange
                
            case .bit32:
                let payloadByteRange: ClosedRange = (payloadByteIndex + 0) ... (payloadByteIndex + 3)
                byteIndex = payloadByteIndex + 4
                map[key] = payloadByteRange
                
            case .unknow:
                throw ProtobufDeccodingError.unknowWireType
            }
        }
        
        return map
    }
    
    private func _deinit() {
        self._map?.removeAll()
        self._dataMutableBufferPointer?.deallocate()
        
        self._map = nil
        self._dataMutableBufferPointer = nil
    }
}
