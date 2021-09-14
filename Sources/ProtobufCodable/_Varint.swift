
enum _Varint {}

extension _Varint {
    
    static func encode<T>(_ value: T) -> UnsafeMutableBufferPointer<Byte>
    where T: UnsignedInteger, T: FixedWidthInteger {
        // find the Leading Non-zero Bit Index
        let lnbIndex: Int = value.leadingNonZeroBitIndex
        guard lnbIndex >= 0 else {
            let mutablePointer = UnsafeMutableBufferPointer<Byte>.allocate(capacity: 0)
            mutablePointer.initialize(repeating: 0)
            return mutablePointer
        }
        
        // Leading Non-zero Bit Count
        let lnbCount: Byte = Byte(truncatingIfNeeded: lnbIndex + 1)
        
        // capacity
        let varintFlagBitCount: Byte = Byte(lnbIndex / 7) + 1 // every 7 bit need a varint flag
        let varintBitCount: Byte = lnbCount + varintFlagBitCount
        let varintByteCount: Int = Int(varintBitCount.bit2ByteScalar)
        
        // alloc memory for varint
        let varintPointer = UnsafeMutableBufferPointer<Byte>.allocate(capacity: varintByteCount)
        varintPointer.initialize(repeating: 0)
        
        // set varint flag
        var varintByteIndex: Int = 0
        var bitIndex: Byte = 0
        while bitIndex < lnbCount {
            var bit8: Byte = value.byte(at: bitIndex)
            bit8.bitTrue(at: 7)
            varintPointer[varintByteIndex] = bit8
            bitIndex += 7
            varintByteIndex += 1
        }
        
        // set last varint flag
        var bit8: Byte = varintPointer[varintByteIndex - 1]
        bit8.bitFalse(at: 7)
        varintPointer[varintByteIndex - 1] = bit8
        
        // init
        return varintPointer
    }
}

extension _Varint {
        
    static func decode<T>(_ varintPointer: UnsafeBufferPointer<Byte>, from byteIndex: Int) -> (readedByteCount: Int, isTruncating: Bool, value: T)
    where T: UnsignedInteger, T: FixedWidthInteger {
        assert(byteIndex < varintPointer.count)
        
        var value: T = 0b0000_0000
        let bitCount = Byte(T.bitWidth)
        var bitIndex: Byte = 0
        var varintByteIndex: Int = byteIndex
        var hasVarintFlagBit: Bool = false
        while bitIndex < bitCount {
            // read byte
            let varintByte: Byte = varintPointer[varintByteIndex]
            
            // value update
            let byte: Byte = varintByte & 0b0111_1111
            value |= T(byte) << bitIndex
            
            // next index
            bitIndex += 7
            varintByteIndex += 1
            
            // has more byte to read ?
            hasVarintFlagBit = (varintByte & 0b1000_0000) == 0b1000_0000
            
            if hasVarintFlagBit == false {
                // not more byte to read
                break
            }
            
            if varintByteIndex >= varintPointer.count {
                // index out of range
                break
            }
        }
        
        // returns
        let readedByteCount = varintByteIndex - byteIndex
        let isTruncating = hasVarintFlagBit
        return (readedByteCount, isTruncating, value)
    }
}


extension _Varint {
    
    static func read(_ varintPointer: UnsafeBufferPointer<Byte>, from byteIndex: Int) -> ClosedRange<Int> {
        assert(byteIndex < varintPointer.count)
        
        var endByteIndex = byteIndex
        while endByteIndex < varintPointer.count {
            let byte: Byte = varintPointer[endByteIndex]
            if (byte & 0b1000_0000) == 0b1000_0000 {
                endByteIndex += 1
            } else {
                break
            }
        }
        
        return byteIndex ... endByteIndex
    }
}
