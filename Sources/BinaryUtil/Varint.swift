

public enum Varint {
    
    public struct Encode<T>
    where T: UnsignedInteger, T: FixedWidthInteger {
        public let value: T
        public let varintByteCount: UInt8
        public let varintPointer: UnsafeMutablePointer<UInt8>
    }
    
    public struct Decode<T>
    where T: UnsignedInteger, T: FixedWidthInteger {
        public let value: T
        public let isTruncating: Bool
    }
}


extension Varint {
    
    public static func encode<T>(_ value: T) -> Encode<T> {
        // find the Most Significant Bit Index
        let msbIndex: Int = value.leadingNonZeroBitIndex
        guard msbIndex >= 0 else {
            let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
            mutablePointer.initialize(to: 0)
            return Encode(value: value, varintByteCount: 1, varintPointer: mutablePointer)
        }
        
        // Most Significant Bit Count
        let msbCount: UInt8 = UInt8(truncatingIfNeeded: msbIndex + 1)
        
        // capacity
        let varintFlagBitCount: UInt8 = UInt8(msbIndex / 7) + 1 // every 7 bit need a varint flag
        let varintBitCount: UInt8 = msbCount + varintFlagBitCount
        let varintByteCount: Int = Int(varintBitCount.bit2ByteScalar)
        
        // alloc memory for varint
        let varintPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: varintByteCount)
        varintPointer.initialize(repeating: 0, count: varintByteCount)
        
        // set varint flag
        var varintByteIndex: Int = 0
        var bitIndex: UInt8 = 0
        while bitIndex < msbCount {
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
        return Encode(value: value, varintByteCount: UInt8(varintByteCount), varintPointer: varintPointer)
    }
}

extension Varint {
    
        public static func decode<T, U>(varint: Varint.Encode<T>) -> Decode<U> {
            self.decode(varintPointer: varint.varintPointer)
        }
        
        public static func decode<T>(varintPointer: UnsafeMutablePointer<UInt8>) -> Decode<T> {
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
            
            return Decode(value: value, isTruncating: hasVarintFlagBit)
        }
}
    

extension Varint.Encode: CustomStringConvertible {
    
    public var description: String {
        var bytes: [UInt8] = []
        var index: Int = 0
        while index < self.varintByteCount {
            let num = self.varintPointer[index]
            bytes.append(num)
            index += 1
        }
        
        bytes.reverse()
        let varintDesc = bytes.map { $0.binaryDescription }.joined(separator: "")
        
        return """
        value: \(self.value)
        count: \(self.varintByteCount)
        bytes: \(varintDesc)
        
        """
    }
}

extension Varint.Decode: CustomStringConvertible {
    
    public var description: String {
        return """
        value: \(self.value)
        isTruncating: \(self.isTruncating)
        
        """
    }
}
