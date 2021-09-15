
import Foundation


final class ProtobufDecodingContainer {
    
    let dataMutableBufferPointer: UnsafeMutableBufferPointer<Byte>
    private(set) var map: [_Key: ClosedRange<Int>]
    
    init(data: Data) {
        // dataMutableBufferPointer
        let dataMutableBufferPointer = UnsafeMutableBufferPointer<Byte>.allocate(capacity: data.count)
        dataMutableBufferPointer.initialize(repeating: 0)
        let copiedBytesCount = data.copyBytes(to: dataMutableBufferPointer)
        assert(copiedBytesCount == data.count)
        self.dataMutableBufferPointer = dataMutableBufferPointer
        
        // map
        self.map = [:]
        let dataBufferPointer = UnsafeBufferPointer<Byte>(dataMutableBufferPointer)
        var byteIndex: Int = 0
        while byteIndex < dataBufferPointer.count {
            // keyVarintDecode
            let keyVarintDecode: (Int, Bool, UInt32) = _Varint.decode(dataBufferPointer, from: byteIndex)
            let keyDecodeByteCount = keyVarintDecode.0
            let keyIsTruncating = keyVarintDecode.1
            let keyRaw = keyVarintDecode.2
            assert(keyIsTruncating == false) // must not truncating `filedNumber`
            
            // payload byte index
            let payloadByteIndex = byteIndex + keyDecodeByteCount
            
            // key
            let key = _Key(rawValue: keyRaw)
            
            // key.wireType
            switch key.wireType {
            case .varint:
                let payloadByteRange = _Varint.readOne(dataBufferPointer, from: payloadByteIndex)
                byteIndex = payloadByteIndex + payloadByteRange.count
                self.map[key] = payloadByteRange
                
            case .bit64:
                let payloadByteRange: ClosedRange = (payloadByteIndex + 0) ... (payloadByteIndex + 7)
                byteIndex = payloadByteIndex + 8
                self.map[key] = payloadByteRange
                
            case .lengthDelimited:
                let payloadVarintDecode: (Int, Bool, UInt32) = _Varint.decode(dataBufferPointer, from: payloadByteIndex)
                let payloadDecodeByteCount = payloadVarintDecode.0
                let payloadIsTruncating = payloadVarintDecode.1
                let payloadRaw = payloadVarintDecode.2
                assert(payloadIsTruncating == false)
                
                let lengthDelimitedByteIndex = payloadByteIndex + payloadDecodeByteCount
                let lengthDelimitedCount = Int(payloadRaw)
                assert(lengthDelimitedCount > 0)
                
                let lengthDelimitedByteRange: ClosedRange = (lengthDelimitedByteIndex + 0) ... (lengthDelimitedByteIndex + lengthDelimitedCount - 1)
                
                byteIndex = lengthDelimitedByteIndex + lengthDelimitedByteRange.count
                self.map[key] = lengthDelimitedByteRange
           
            case .bit32:
                let payloadByteRange: ClosedRange = (payloadByteIndex + 0) ... (payloadByteIndex + 3)
                byteIndex = payloadByteIndex + 4
                self.map[key] = payloadByteRange
                
            case .unknow:
                fatalError("unknow wire type")
            }
        }
    }
    
    deinit {
        self.dataMutableBufferPointer.deallocate()
    }
}

