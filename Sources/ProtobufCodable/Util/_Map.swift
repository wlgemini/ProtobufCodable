

struct _Dictionary<Key, Value>
where Key: Hashable {
    
    init(minimumCapacity: Int = 0) {
        
    }
    
    @inlinable
    subscript(key: Key) -> Value? {
        get {
            fatalError()
        }
        
        set {
            fatalError()
        }
    }
    
    // MARK: Private
    private let _pointer: UnsafeMutableBufferPointer<>
}

extension _Dictionary {
    
}
