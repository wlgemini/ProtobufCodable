

public enum Varint {
    
//    public struct Encode<T>
//    where  {
//        public let value: T
//        public let varintByteCount: UInt8
//        public let varintPointer: UnsafeMutablePointer<UInt8>
//    }
//
//    public struct Decode<T>
//    where T: UnsignedInteger, T: FixedWidthInteger {
//        public let value: T
//        public let isTruncating: Bool
//    }
}


extension Varint {
    
    public static func encode<T>(_ value: T) -> UnsafeMutableBufferPointer<UInt8>
    where T: UnsignedInteger, T: FixedWidthInteger {
        // find the Leading Non-zero Bit Index
        let lnbIndex: Int = value.leadingNonZeroBitIndex
        guard lnbIndex >= 0 else {
            let mutablePointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: 0)
            mutablePointer.initialize(repeating: 0)
            return mutablePointer
        }
        
        // Leading Non-zero Bit Count
        let lnbCount: UInt8 = UInt8(truncatingIfNeeded: lnbIndex + 1)
        
        // capacity
        let varintFlagBitCount: UInt8 = UInt8(lnbIndex / 7) + 1 // every 7 bit need a varint flag
        let varintBitCount: UInt8 = lnbCount + varintFlagBitCount
        let varintByteCount: Int = Int(varintBitCount.bit2ByteScalar)
        
        // alloc memory for varint
        let varintPointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: varintByteCount)
        varintPointer.initialize(repeating: 0)
        
        // set varint flag
        var varintByteIndex: Int = 0
        var bitIndex: UInt8 = 0
        while bitIndex < lnbCount {
            var bit8: UInt8 = value.byte(at: bitIndex)
            bit8.bitTrue(at: 7)
            varintPointer[varintByteIndex] = bit8
            bitIndex += 7
            varintByteIndex += 1
        }
        
        // set last varint flag
        var bit8: UInt8 = varintPointer[varintByteIndex - 1]
        bit8.bitFalse(at: 7)
        varintPointer[varintByteIndex - 1] = bit8
        
        // init
        return varintPointer
    }
}

extension Varint {
        
        public static func decode<T>(varintPointer: UnsafeBufferPointer<UInt8>) -> (isTruncating: Bool, value: T)
        where T: UnsignedInteger, T: FixedWidthInteger {
            var value: T = 0b0000_0000
            let bitCount = UInt8(T.bitWidth)
            var bitIndex: UInt8 = 0
            var varintByteIndex: Int = 0
            var hasVarintFlagBit: Bool = false
            while bitIndex < bitCount {
                let varintByte: UInt8 = varintPointer[varintByteIndex]
                
                let byte: UInt8 = varintByte & 0b0111_1111
                value |= T(byte) << bitIndex
                
                hasVarintFlagBit = (varintByte & 0b1000_0000) != 0
                if hasVarintFlagBit {
                    bitIndex += 7
                    varintByteIndex += 1
                } else {
                    break
                }
            }
            
            return (isTruncating: hasVarintFlagBit, value: value)
        }
}
    

//extension Varint.Encode: CustomStringConvertible {
//
//    public var description: String {
//        var bytes: [UInt8] = []
//        var index: Int = 0
//        while index < self.varintByteCount {
//            let num = self.varintPointer[index]
//            bytes.append(num)
//            index += 1
//        }
//
//        bytes.reverse()
//        let varintDesc = bytes.map { $0.binaryDescription }.joined(separator: "")
//
//        return """
//        value: \(self.value)
//        count: \(self.varintByteCount)
//        bytes: \(varintDesc)
//
//        """
//    }
//}
//
//extension Varint.Decode: CustomStringConvertible {
//
//    public var description: String {
//        return """
//        value: \(self.value)
//        isTruncating: \(self.isTruncating)
//
//        """
//    }
//}
