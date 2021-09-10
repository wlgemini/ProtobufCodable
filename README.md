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

### Grammar
#### Specifying Field Rules
- singular: a well-formed message can have `zero` or `one` of this field (but not more than one). And this is the default field rule for `proto3` syntax.
- `repeated`: this field can be repeated any number of times (including `zero`) in a well-formed message. **The order of the `repeated` values will be preserved**.
In proto3, `repeated` fields of scalar numeric types use `packed encoding` by default.

#### `packed encoding` ?

#### Reserved Fields (Not useful)
Specify that the field numbers of your deleted fields are `reserved`. The protocol buffer compiler will complain if any future users try to use these field identifiers.

#### Default Values ⚠️
When a message is parsed, if the encoded message does not contain a particular singular element, the corresponding field in the parsed object is set to the default value for that field.
(So, when a message is serialized, if the singular element is default value, then the singular element will be ignored, it will not encoded in the result data.)

These defaults are type-specific:

- For strings, the default value is the empty string.
- For bytes, the default value is empty bytes.
- For bools, the default value is false.
- For numeric types, the default value is zero.
- For enums, the default value is the first defined enum value, which must be 0.
- For message fields, the field is not set. Its exact value is language-dependent. See the generated code guide for details.
- The default value for `repeated` fields is empty (generally an empty list in the appropriate language)

Note that for scalar message fields, once a message is parsed there's no way of telling whether a field was explicitly set to the default value (for example whether a boolean was set to false) or just not set at all: you should bear this in mind when defining your message types. 
For example, don't have a boolean that switches on some behaviour when set to false if you don't want that behaviour to also happen by default. 
Also note that if a scalar message field is set to its default, the value will not be serialized on the wire.

#### Enumerations
every enum definition must contain a constant that maps to zero as its first element. This is because:

- There must be a `zero` value, so that we can use `0` as **a numeric default value**.
- The `zero` value needs to be the first element, for compatibility with the `proto2` semantics where the **first enum value is always the default**.

You can define aliases by assigning the same value to different enum constants. To do this you need to set the allow_alias option to true, otherwise the protocol compiler will generate an error message when aliases are found.

**Enumerator constants must be in the range of a 32-bit integer. Since enum values use varint encoding on the wire, negative values are inefficient and thus not recommended.**


During deserialization, unrecognized enum values will be preserved in the message, though how this is represented when the message is deserialized is language-dependent. In languages that support open enum types with values outside the range of specified symbols, such as C++ and Go, the unknown enum value is simply stored as its underlying integer representation. In languages with closed enum types such as Java, a case in the enum is used to represent an unrecognized value, and the underlying integer can be accessed with special accessors. In either case, if the message is serialized the unrecognized value will still be serialized with the message.


#### Optional And Repeated Elements
For any non-repeated fields in proto3, or optional fields in proto2, the encoded message may or may not have a key-value pair with that field number.

Normally, an encoded message would never have more than one instance of a non-repeated field. However, parsers are expected to handle the case in which they do. For numeric types and strings, if the same field appears multiple times, the parser accepts the last value it sees. For embedded message fields, the parser merges multiple instances of the same field, as if with the Message::MergeFrom method – that is, all singular scalar fields in the latter instance replace those in the former, singular embedded messages are merged, and repeated fields are concatenated. The effect of these rules is that parsing the concatenation of two encoded messages produces exactly the same result as if you had parsed the two messages separately and merged the resulting objects.


### Implementation
#### Remaind
#### Platform independent Numeric
- `Int` / `UInt` use `init(littleEndian value: Int)` / `.littleEndian` to encode/decode.
- `Float` / `Double` use `init(bitPattern: UInt64)` / `.bitPattern` to encode/decode. (using *IEEE 754 specification*)

#### Numeric Encode 
- `UInt(LittleEndian) >>> UInt (LittleEndian Fixed)`: `UInt(LittleEndian)` > `UInt (LittleEndian Fixed)`
- `UInt(LittleEndian) >>> UInt (LittleEndian Varint)`: `UInt(LittleEndian)` > `Varint` > `UInt (LittleEndian Varint)`
- `UInt >>> UInt(LittleEndian)`: `UInt` > `.littleEndian` > `UInt(LittleEndian)`
- `Int >>> UInt`: `Int` > `ZigZag` > `UInt`
- `Float >>> UInt`: `Float` > `.bitPattern` > `UInt`

#### Numeric Decode
*above sequence reversed* 







