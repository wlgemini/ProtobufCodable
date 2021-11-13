//import Foundation
//
//
//final class _HashTable<Key, Value> where Key: Swift.Hashable {
//
//    init() {
//        self._newBuckets = Swift.UnsafeMutableBufferPointer.allocate(capacity: Int(self._newCapacity))
//        self._newBuckets.initialize(repeating: nil)
//    }
//
//    subscript(key: Key) -> Value? {
//        get {
//            fatalError()
//        }
//
//        set {
//            if self._isExpanding {
//
//            } else {
//                let hashValue = self._hashValue(key: key)
//                let index = self._index(hashValue: hashValue, capacity: self._newCapacity)
//                if let bucket = self._newBuckets[index] {
//                    self._set(key: key, value: newValue, bucket: bucket)
//                } else {
//
//                }
//            }
//        }
//    }
//
//    func removeValue(for key: Key) -> Value? {
//        fatalError()
//    }
//
//    deinit {
//        self._oldBuckets?.deallocate()
//        self._newBuckets.deallocate()
//    }
//    
//    // MARK: Private
//    private var _isExpanding: Swift.Bool = false
//
//    private var _newCount: Swift.UInt32 = 0
//    private var _newCapacity: Swift.UInt32 = _Integer.nextPowerOf2ClampedToUInt32Max(4)
//    private var _newBuckets: Swift.UnsafeMutableBufferPointer<_Node<Key, Value>?>
//
//    private var _oldCount: Swift.UInt32?
//    private var _oldCapacity: Swift.UInt32?
//    private var _oldBuckets: Swift.UnsafeMutableBufferPointer<_Node<Key, Value>?>?
//
//    private func _hashValue(key: Key) -> Swift.UInt32 {
//        var hasher = Swift.Hasher()
//        key.hash(into: &hasher)
//        return Swift.UInt32.init(truncatingIfNeeded: hasher.finalize())
//    }
//
//    private func _index(hashValue: Swift.UInt32, capacity: Swift.UInt32) -> Swift.UInt32 {
//        return hashValue & capacity
//    }
//
//    private func _get(key: Key, buckets: Swift.UnsafeMutableBufferPointer<_Bucket<Key, Value>?>, capacity: Swift.UInt32) {
//
//    }
//
//
//    private func _set(key: Key, value: Value, nodes: Swift.UnsafeMutableBufferPointer<_Node<Key, Value>?>, capacity: Swift.UInt32) {
//        let hashValue = self._hashValue(key: key)
//        let index = Int(self._index(hashValue: hashValue, capacity: capacity))
//
//
//        var offset: UInt8 = 0
//        if var node: _Node<Key, Value>? = nodes[index] {
//            if let next = node?.next {
//
//            } else {
//                let next = UnsafeMutablePointer<_Node<Key, Value>>.allocate(capacity: 1)
//                next.initialize(to: _Node(key: key, value: value, next: nil))
//                node?.next = next
//            }
//
//
//        } else {
//            nodes[index] = _Node(key: key, value: value, next: nil)
//        }
//
//
//
//
//
//
//        while offset < 10 {
//            if var node
//        }
//
//        let node = nodes[index]
//
//
//
//
//
//
//        if var bk = buckets[index] {
//            if bk.kv.key == key {
//                bk.kv.value = value
//                buckets[index] = bk
//            } else if let next = bk.next {
//                let p2 = next.pointee
//                if p2.value0.key == key {
//                    p2.value0.value = value
//                    next.pointee = p2
//                } else if var value1 = p2.value1 {
//                    if value1.key == key {
//                        value1.value = value
//                        p2.value1?.value = value
//
//                    }
//                }
//            } else {
//
//            }
//        } else {
//            buckets[index] = _Bucket(value: _KeyValuePair(key: key, value: value), next: nil)
//        }
//    }
//}
//
//
//struct _Node<Key, Value> where Key: Hashable {
//
//    let key: Key
//
//    var value: Value
//
//    var next: UnsafeMutablePointer<_Node<Key, Value>>?
//}
