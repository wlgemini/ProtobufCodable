
/*
class ProtobufDecoder: Decoder {

    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer<Key>(ProtobufKeyedDecodingContainer())
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        ProtobufUnkeyedDecodingContainer(codingPath: [], count: nil, isAtEnd: false, currentIndex: 0)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        ProtobufSingleValueDecodingContainer(codingPath: [])
    }
}
*/
