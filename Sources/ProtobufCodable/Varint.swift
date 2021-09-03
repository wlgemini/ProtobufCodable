

public struct Varint<T: UnsignedInteger> {
    
    let capacity: Int = 0
    
    let mutablePointer: UnsafeMutablePointer<UInt8> = .allocate(capacity: 0)
    
    public static func encode(_ value: T) -> Varint<T> {
        // find the Most Significant Bit Index
        let msbIndex: Int8 = self._mostSignificantBitIndex(value)
        guard msbIndex >= 0 else {
            return Varint()
        }
        
        // Most Significant Bit Count
        let msbBitCount: UInt8 = UInt8(msbIndex + 1)
        
        // capacity
        let varintFlagBitCount: UInt8 = (msbBitCount / 7) + 1 // every 7 bit need a varint flag
        let varintBitCount: UInt8 = msbBitCount + varintFlagBitCount
        
        // alloc memory for capacity
        let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(varintBitCount.bit2ByteScalar))
        
        //
        var bitIndex: UInt8 = 0
        var carryBitCount: UInt8 = 0 // 进位bits个数
        var carryBit: UInt8 = 0 // 进位bits
        
        while bitIndex < msbBitCount {
            var bit8: UInt8 = value[bitIndex]
            let highBit1Mask: UInt8 = 0b1000_0000
            
            let nextCarryBitCount: UInt8 = carryBitCount + 1 // varint flag take 1 bit
            let nextCarryBitMask: UInt8 = highBit1Mask >> nextCarryBitCount
            var nextCarryBit: UInt8 = byte & nextCarryBitMask
            // nextCarryBit = nextCarryBit >> (8 - nextCarryBitCount)
            
            valueByte = valueByte << carryBitCount
            valueByte = valueByte | carryBit
        }
        
    }
    
//    public static func decode(_ pointer: UnsafeBufferPointer<UInt8>) {
//
//    }
}


extension Varint {
    
    /// Find the Most Significant Bit Index
    /// - Parameter value: any unsigned integer
    /// - Returns: -1 when not find
    static func _mostSignificantBitIndex<U: UnsignedInteger>(_ value: U) -> Int8 {
        var lb: Int8 = -1
        var rb: Int8 = Int8(MemoryLayout<T>.size).byte2BitScalar
        
        while (lb + 1) < rb {
            let mid = (lb + rb) / 2
            if (value >> mid) != 0 {
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
    var bit2ByteScalar: Self { self >> 3 }
    
    @inlinable
    var byte2BitScalar: Self { self << 3 }
    
    /// get Byte from index
    /// - Parameter bitIndex: bit index
    /// - Returns: Byte
    @inlinable
    subscript(bitIndex: UInt8) -> UInt8 {
        assert(MemoryLayout<Self>.size.byte2BitScalar > bitIndex)
        
        let shift = bitIndex
        let bitFullMask: Self = 0b1111_1111
        let shiftMask = bitFullMask << shift
        let target = self & shiftMask
        return UInt8(target >> shift)
    }
}
