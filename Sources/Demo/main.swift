
import ProtobufCodable

let v1: UInt64 = 0b0000_0001 // 1
let v2: UInt64 = 0b0000_0001_0000_0001 // 2
let v3: UInt64 = 0b0000_0001_0000_0001_0000_0001 // 3
let v4: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001 // 4
let v5: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 5
let v6: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 6
let v7: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 7
let v8: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 8
let v8Full: UInt64 = 0b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111 // 8

let e1 = Varint.encode(v1)
let e2 = Varint.encode(v2)
let e3 = Varint.encode(v3)
let e4 = Varint.encode(v4)
let e5 = Varint.encode(v5)
let e6 = Varint.encode(v6)
let e7 = Varint.encode(v7)
let e8 = Varint.encode(v8)
let e8Full = Varint.encode(v8Full)

print("e1", e1)
print("e2", e2)
print("e3", e3)
print("e4", e4)
print("e5", e5)
print("e6", e6)
print("e7", e7)
print("e8", e8)
print("e8Full", e8Full)


let d1: Varint.Decode<UInt64> = Varint.decode(varint: e1)
let d2: Varint.Decode<UInt64> = Varint.decode(varint: e2)
let d3: Varint.Decode<UInt64> = Varint.decode(varint: e3)
let d4: Varint.Decode<UInt64> = Varint.decode(varint: e4)
let d5: Varint.Decode<UInt64> = Varint.decode(varint: e5)
let d6: Varint.Decode<UInt64> = Varint.decode(varint: e6)
let d7: Varint.Decode<UInt64> = Varint.decode(varint: e7)
let d8: Varint.Decode<UInt64> = Varint.decode(varint: e8)
let d8Full: Varint.Decode<UInt64> = Varint.decode(varint: e8Full)
let d8Trun: Varint.Decode<UInt8> = Varint.decode(varint: e8)

print("d1", d1)
print("d2", d2)
print("d3", d3)
print("d4", d4)
print("d5", d5)
print("d6", d6)
print("d7", d7)
print("d8", d8)
print("d8Full'", d8Full)
print("d8Turn", d8Trun)


assert(d1.value == e1.value)
assert(d2.value == e2.value)
assert(d3.value == e3.value)
assert(d4.value == e4.value)
assert(d5.value == e5.value)
assert(d6.value == e6.value)
assert(d7.value == e7.value)
assert(d8.value == e8.value)
assert(d8Full.value == e8Full.value)
assert(d8Trun.value != e8.value)
