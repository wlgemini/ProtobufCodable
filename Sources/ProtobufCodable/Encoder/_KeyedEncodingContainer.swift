
final class _KeyedEncodingContainer {
    
    let dataMutableBufferPointer: UnsafeMutableBufferPointer<Byte> = .allocate(capacity: 0)
    
    
    deinit {
        self.dataMutableBufferPointer.deallocate()
    }
    
    // MARK: Private
    private var _map: [_Key: UnsafeMutableBufferPointer<Byte>] = [:]
}


extension _KeyedEncodingContainer {
    
    func encodeVarint<T>(_ value: T, for key: _Key)
    where T: FixedWidthInteger, T: UnsignedInteger {
//        let pointer = _Varint.encode(value)
//        self._map[key] = pointer
    }
    
    func encodeFixedBit<T>(_ value: T, for key: _Key)
    where T: FixedWidthInteger, T: UnsignedInteger {
        let pointer = _FixedBit.encode(value)
        self._map[key] = pointer
    }
    
    func encodeLengthDelimited(_ pointer: UnsafeMutableBufferPointer<Byte>, for key: _Key) {
        self._map[key] = pointer
        
        
        
    }
}
