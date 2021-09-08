# ProtobufCodable
Swift Codable for protobuf.

ref:
- [repo BetterCodable](https://github.com/marksands/BetterCodable)
- [repo BinaryCodable](https://github.com/jverkoey/BinaryCodable)
- [repo KeyedCodable](https://github.com/dgrzeszczak/KeyedCodable)
- [protobuf encoding format](https://developers.google.cn/protocol-buffers/docs/encoding)
- [varint](https://en.wikipedia.org/wiki/Variable-length_quantity)
- [`Base 128 Varints` aka `Little Endian 128`](https://basicdrift.com/explore-encoding-base-128-varints-41665a0dca36)
- [ZigZag](https://blog.csdn.net/weixin_43708622/article/details/111397290)
- [A Binary Coder for Swift](https://www.mikeash.com/pyblog/friday-qa-2017-07-28-a-binary-coder-for-swift.html)
- [why `required` and `optional` is removed in protocol buffers 3](https://stackoverflow.com/questions/31801257/why-required-and-optional-is-removed-in-protocol-buffers-3)
- [efficient conversion of double to big endian](https://stackoverflow.com/questions/45775554/swift-4-efficient-conversion-of-double-to-big-endian)

### Remaind
- `Int` / `UInt` use `init(littleEndian value: Int)` / `.littleEndian` to encode/decode.
- `Float` / `Double` use `init(bitPattern: UInt64)` / `.bitPattern` to encode/decode. (using *IEEE 754 specification*)


### Encode 
- `UInt`: `UInt` > `.littleEndian` > `Varint` > `UInt8*`
- `Int`: `Int` > `.littleEndian` > `ZigZag` > `Varint` > `UInt8*`
- `Float/Double`: `Float/Double` > `.bitPattern` > `Varint` > `UInt8*`

### Decode
- `UInt`: `UInt8*` > `Varint` > `init(littleEndian value: UInt)` > `UInt`
- `Int`: `UInt8*` > `Varint` > `ZigZag` > `init(littleEndian value: Int)` > `Int`
- `Float` / `Double`: `UInt8*` > `Varint` > `init(bitPattern: UInt64)` > `Float` / `Double`

