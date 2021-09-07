
/*
public final class ProtobufEncoder: Encoder {
    
    /// The path of coding keys taken to get to this point in encoding.
    public var codingPath: [CodingKey] = []

    /// Any contextual information set by the user for encoding.
    public var userInfo: [CodingUserInfoKey : Any] = [:]

    /// Returns an encoding container appropriate for holding multiple values
    /// keyed by the given key type.
    ///
    /// You must use only one kind of top-level encoding container. This method
    /// must not be called after a call to `unkeyedContainer()` or after
    /// encoding a value through a call to `singleValueContainer()`
    ///
    /// - parameter type: The key type to use for the container.
    /// - returns: A new keyed encoding container.
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        KeyedEncodingContainer<Key>(ProtobufKeyedEncodingContainer<Key>())
    }

    /// Returns an encoding container appropriate for holding multiple unkeyed
    /// values.
    ///
    /// You must use only one kind of top-level encoding container. This method
    /// must not be called after a call to `container(keyedBy:)` or after
    /// encoding a value through a call to `singleValueContainer()`
    ///
    /// - returns: A new empty unkeyed container.
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        ProtobufUnkeyedEncodingContainer()
    }

    /// Returns an encoding container appropriate for holding a single primitive
    /// value.
    ///
    /// You must use only one kind of top-level encoding container. This method
    /// must not be called after a call to `unkeyedContainer()` or
    /// `container(keyedBy:)`, or after encoding a value through a call to
    /// `singleValueContainer()`
    ///
    /// - returns: A new empty single value container.
    public func singleValueContainer() -> SingleValueEncodingContainer {
        ProtobufSingleValueEncodingContainer()
    }
}

 */
