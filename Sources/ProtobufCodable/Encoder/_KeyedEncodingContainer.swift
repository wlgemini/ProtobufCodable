
final class _KeyedEncodingContainer {
    
    let dataMutableBufferPointer: UnsafeMutableBufferPointer<UInt8> = .allocate(capacity: 0)
    
    
    deinit {
        self.dataMutableBufferPointer.deallocate()
    }
    
    // MARK: Private
    private var _map: [Key: UnsafeMutableBufferPointer<UInt8>] = [:]
}


extension _KeyedEncodingContainer {
    
    func encodeVarint<T>(_ value: T, for key: Key)
    where T: FixedWidthInteger, T: UnsignedInteger {
//        let pointer = _Varint.encode(value)
//        self._map[key] = pointer
    }
    
    func encodeFixedBit<T>(_ value: T, for key: Key)
    where T: FixedWidthInteger, T: UnsignedInteger {
        let pointer = _FixedBit.encode(value)
        self._map[key] = pointer
    }
    
    func encodeLengthDelimited(_ pointer: UnsafeMutableBufferPointer<UInt8>, for key: Key) {
        self._map[key] = pointer
        
        
        
    }
}
