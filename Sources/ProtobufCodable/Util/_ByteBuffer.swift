

final class _ByteBuffer {
    
    var index: Int
    private(set) var pointer: UnsafeMutableRawBufferPointer
    
    init(with capacity: Int) {
        self.index = 0
        self.pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: capacity, alignment: 1)
    }
    
    init<S>(from source: S) throws
    where S: Collection, S.Element == UInt8 {
        self.index = 0
        self.pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: source.count, alignment: 1)
        let (_, initialized) = self.pointer.initializeMemory(as: S.Element.self, from: source)
        if initialized.count != source.count {
            throw ProtobufDeccodingError.corruptedData("data capacity not match")
        }
    }
    
    deinit {
        self.pointer.deallocate()
    }
}


extension _ByteBuffer {
    
    func read() {
        
    }
}
