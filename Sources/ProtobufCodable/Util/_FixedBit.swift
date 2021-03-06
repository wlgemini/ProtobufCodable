
enum _FixedBit {}


extension _FixedBit {
    
    static func encode<T>(_ value: T) -> UnsafeMutableBufferPointer<UInt8>
    where T: FixedWidthInteger, T: UnsignedInteger {
        let bitCount = value.bitWidth
        let mutablePointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: _Integer.bit2ByteScalar(bitCount))
        mutablePointer.initialize(repeating: 0)
        
        var bitIndex: Int = 0
        var byteIndex: Int = 0
        while bitIndex < bitCount {
            let byte = _Integer.byte(value, at: bitIndex)
            mutablePointer[byteIndex] = byte
            
            bitIndex += 8
            byteIndex += 1
        }
        
        return mutablePointer
    }
}

extension _FixedBit {
    
    static func decode<T>(_ pointer: UnsafeBufferPointer<UInt8>, from byteIndex: Int) -> T
    where T: FixedWidthInteger, T: UnsignedInteger {
        var value: T = 0b0000_0000
        let bitCount: Int = T.bitWidth
        var bitIndex: Int = 0
        var byteIndexOffset: Int = 0
        while bitIndex < bitCount {
            let byte = pointer[byteIndex + byteIndexOffset]
            value |= T(byte) << bitIndex
            
            bitIndex += 8
            byteIndexOffset += 1
        }
        return value
    }
}
