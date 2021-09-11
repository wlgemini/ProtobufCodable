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
- [🤙Dynamic CodingKey](https://medium.com/tdg-engineering/combined-propertywrapper-with-codable-swift-368dc4aa2703)

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

#### Updating A Message Type
- **int32, uint32, int64, uint64, and bool are all compatible** – this means you can change a field from one of these types to another without breaking forwards- or backwards-compatibility. If a number is parsed from the wire which doesn't fit in the corresponding type, you will get the same effect as if you had cast the number to that type in C++ (e.g. if a 64-bit number is read as an int32, it will be truncated to 32 bits).
- **sint32 and sint64 are compatible with each other but are not compatible with the other integer types**.
- **string and bytes are compatible as long as the bytes are valid UTF-8**.
- **Embedded messages are compatible with bytes if the bytes contain an encoded version of the message**. (proto2 / proto3 message?)
- **fixed32 is compatible with sfixed32, and fixed64 with sfixed64.**
- **For string, bytes, and message fields, optional is compatible with repeated.** Given serialized data of a repeated field as input, clients that expect this field to be optional will take the last input value if it's a primitive type field or merge all input elements if it's a message type field. Note that this is not generally safe for numeric types, including bools and enums. Repeated fields of numeric types can be serialized in the packed format, which will not be parsed correctly when an optional field is expected.
- **enum is compatible with int32, uint32, int64, and uint64 in terms of wire format (note that values will be truncated if they don't fit)**. However be aware that client code may treat them differently when the message is deserialized: for example, unrecognized proto3 enum types will be preserved in the message, but how this is represented when the message is deserialized is language-dependent. Int fields always just preserve their value.
- Changing a single value into a member of a new oneof is safe and binary compatible. Moving multiple fields into a new oneof may be safe if you are sure that no code sets more than one at a time. Moving any fields into an existing oneof is not safe.

#### Unknown Fields
Unknown fields are well-formed protocol buffer serialized data representing fields that the parser does not recognize.

*In versions 3.5 and later, unknown fields are retained during parsing and included in the serialized output.* ?

#### Any
The Any message type lets you use messages as embedded types without having their .proto definition. An Any contains an arbitrary serialized message as bytes, along with a URL that acts as a globally unique identifier for and resolves to that message's type.

The default type URL for a given message type is `type.googleapis.com/_packagename_._messagename_`.


#### Oneof
If you have a message with many fields and where at most one field will be set at the same time, you can enforce this behavior and save memory by using the oneof feature.

Oneof fields are like regular fields except all the fields in a oneof share memory, and at most one field can be set at the same time. Setting any member of the oneof automatically clears all the other members. 
```
message SampleMessage {
  oneof test_oneof {
    string name = 4;
    SubMessage sub_message = 9;
  }
}
```
**You can add fields of any type, except `map` fields and `repeated` fields.** ?

In your generated code, oneof fields have the same getters and setters as regular fields. You also get a special method for checking which value (if any) in the oneof is set. 

- A `oneof` cannot be repeated.
- Reflection APIs work for oneof fields.
- If you set a `oneof` field to the default value (such as setting an int32 oneof field to 0), the "case" of that `oneof` field will be set, and the value will be serialized on the wire.

#### Maps 
`Map` fields cannot be `repeated`.

The `map` syntax is equivalent to the following on the wire, so protocol buffers implementations that do not support maps can still handle your data:

```
message MapFieldEntry {
  key_type key = 1;
  value_type value = 2;
}

repeated MapFieldEntry map_field = N;
```

Any protocol buffers implementation that supports maps must both produce and accept data that can be accepted by the above definition.

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







