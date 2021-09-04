

public struct Varint<T: UnsignedInteger> {
    
    let count: UInt8
    
    let mutablePointer: UnsafeMutablePointer<UInt8>
    
    public static func encode(_ value: T) -> Varint<T> {
        // find the Most Significant Bit Index
        let msbIndex: Int8 = value.mostSignificantBitIndex
        guard msbIndex >= 0 else {
            let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 0)
            mutablePointer.initialize(to: 0)
            return Varint(count: 0, mutablePointer: mutablePointer)
        }
        
        // Most Significant Bit Count
        let msbCount: UInt8 = UInt8(msbIndex + 1)
        
        // capacity
        let varintFlagBitCount: UInt8 = UInt8(msbIndex / 7) + 1 // every 7 bit need a varint flag
        let varintBitCount: UInt8 = msbCount + varintFlagBitCount
        let varintByteCount: Int = Int(varintBitCount.bit2ByteScalar)
        
        // alloc memory for varint
        let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: varintByteCount)
        mutablePointer.initialize(repeating: 0, count: varintByteCount)
        
        // set varint
        var varintByteIndex: Int = 0
        var bitIndex: UInt8 = 0
        while bitIndex < msbCount {
            let bit8: UInt8 = value.getByte(bitIndex: bitIndex)
            let flagedBit8: UInt8 = bit8 | 0b1000_0000
            mutablePointer[varintByteIndex] = flagedBit8
            bitIndex += 7
            varintByteIndex += 1
        }
        
        return Varint(count: UInt8(varintByteCount), mutablePointer: mutablePointer)
    }
    
//    public static func decode(_ pointer: UnsafeBufferPointer<UInt8>) {
//
//    }
}

extension Varint: CustomStringConvertible {
    
    public var description: String {
        var bytes: [UInt8] = []
        var index: Int = 0
        while index < self.count {
            bytes.append(self.mutablePointer[index])
        }
        
        let desc = """
        
        count: \(self.count)
        byte: \()
        """
    }
}


extension UnsignedInteger {
    
    /// Find the Most Significant Bit Index, -1 when not find
    var mostSignificantBitIndex: Int8 {
        var lb: Int8 = -1
        var rb: Int8 = Int8(MemoryLayout<Self>.size).byte2BitScalar
        
        while (lb + 1) < rb {
            let mid = (lb + rb) / 2
            if (self >> mid) != 0 {
                lb = mid
            } else {
                rb = mid
            }
        }
        
        return lb
    }
}



extension BinaryInteger {
    
    @inlinable
    var bit2ByteScalar: Self {
        if (self & 0b0000_0111) == 0 {
            return self >> 3 // 没有余数
        } else {
            return (self >> 3) + 1 // 有余数
        }
    }
    
    @inlinable
    var byte2BitScalar: Self { self << 3 }
    
    /// get Byte from Bit index
    /// - Parameter bitIndex: bit index
    /// - Returns: Byte
    @inlinable
    func getByte(bitIndex: UInt8) -> UInt8 {
        // the biggest UInt128 take 16 byte, which within the range of 0 ~ 255 that UInt8 can represent.
        let bitCount: UInt8 = UInt8(MemoryLayout<Self>.size.byte2BitScalar)
        assert(bitCount > bitIndex)
        
        return UInt8((self >> bitIndex) & 0b1111_1111)
    }
}
