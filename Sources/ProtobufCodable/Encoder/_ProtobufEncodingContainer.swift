
final class _ProtobufEncodingContainer {
    
    let dataMutableBufferPointer: UnsafeMutableBufferPointer<Byte> = .allocate(capacity: 0)
    
    
    deinit {
        self.dataMutableBufferPointer.deallocate()
    }
    
    // MARK: Private
    private var _map: [_Key: UnsafeMutableBufferPointer<Byte>] = [:]
}


extension _ProtobufEncodingContainer {
    
    func encodeVarint<T>(_ value: T, for key: _Key)
    where T: FixedWidthInteger, T: UnsignedInteger {
        let pointer = _Varint.encode(value)
        self._map[key] = pointer
    }
    
    func encodeFixedBit<T>(_ value: T, for key: _Key)
    where T: FixedWidthInteger, T: UnsignedInteger {
        let pointer = _FixedBit.encode(value)
        self._map[key] = pointer
    }
    
    func encodeLengthDelimited(_ value: [UInt8], for key: _Key) {
        
    }
    
    func encodeLengthDelimited(_ value: String, for key: _Key) {
        
    }
    
    func encodeLengthDelimited<EmbeddedMessage>(_ value: EmbeddedMessage, for key: _Key) {
        
    }
    
    func encodeLengthDelimited<EmbeddedMessage>(_ value: Array<EmbeddedMessage>, for key: _Key) {
        
    }
}
