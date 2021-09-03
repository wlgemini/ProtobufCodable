

struct LinkList<T> {
    var count: Int
    var header: Optional<UnsafePointer<Node<T>>> = .none
    var footer: Optional<UnsafePointer<Node<T>>> = .none
}

extension LinkList {
    
//    mutating func append(_ value: T) {
//
//    }
//
//    mutating func remove() -> T {
//
//    }
}


struct Node<T> {
    var prev: Optional<UnsafePointer<Node<T>>> = .none
    var next: Optional<UnsafePointer<Node<T>>> = .none
    var value: T
}
