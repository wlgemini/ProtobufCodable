
enum _Scalar {
    
    enum Encoder {}
    enum Decoder {}
}

extension _Scalar.Encoder {
    
    func float(_ value: Float) -> UInt32 {
        value.bitPattern.littleEndian
    }
    
    func double(_ value: Double) -> UInt64 {
        value.bitPattern.littleEndian
    }
    
    func int32(_ value: Int32) -> UnsafeMutableBufferPointer<Byte> {
        _Varint.encode(value.littleEndian)
    }
    
    func int64(_ value: Int64) -> UnsafeMutableBufferPointer<Byte> {
        _Varint.encode(value.littleEndian)
    }
    
    func uint32(_ value: UInt32) -> UnsafeMutableBufferPointer<Byte> {
        _Varint.encode(value.littleEndian)
    }
    
    func uint64(_ value: UInt64) -> UnsafeMutableBufferPointer<Byte> {
        _Varint.encode(value.littleEndian)
    }
    
    func sint32(_ value: Int32) -> UnsafeMutableBufferPointer<Byte> {
        let zigzag: UInt32 = _ZigZag.encode(value.littleEndian)
        return _Varint.encode(zigzag)
    }
    
    func sint64(_ value: Int64) -> UnsafeMutableBufferPointer<Byte> {
        let zigzag: UInt32 = _ZigZag.encode(value.littleEndian)
        return _Varint.encode(zigzag)
    }
    
    func fixed32(_ value: UInt32) -> UInt32 {
        value.littleEndian
        
    }
    
    func fixed64(_ value: UInt64) -> UInt64 {
        value.littleEndian
    }
    
    func sfixed32(_ value: Int32) -> Int32 {
        value.littleEndian
    }
    
    func sfixed64(_ value: Int64) -> Int64 {
        value.littleEndian
    }
    
    func bool(_ value: Bool) -> UInt8 {
        value ? 0b0000_0001 : 0b0000_0000
    }
    
    func string(_ value: String) -> UnsafeMutableBufferPointer<Byte> {
        let utf8 = value.utf8
        let count = utf8.count
        let pointer = UnsafeMutableBufferPointer<Byte>.allocate(capacity: count)
        pointer.assign(repeating: 0)
        for (index, byte) in utf8.enumerated() {
            pointer[index] = byte
        }
        return pointer
    }
    
    func bytes(_ value: [Byte]) -> UnsafeMutableBufferPointer<Byte> {
        let count = value.count
        let pointer = UnsafeMutableBufferPointer<Byte>.allocate(capacity: count)
        pointer.assign(repeating: 0)
        for (index, byte) in value.enumerated() {
            pointer[index] = byte
        }
        return pointer
    }
}
