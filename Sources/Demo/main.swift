
import ProtobufCodable

let a: UInt64 = 0b0000_0001 // 1
let b: UInt64 = 0b0000_0001_0000_0001 // 2
let c: UInt64 = 0b0000_0001_0000_0001_0000_0001 // 3
let d: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001 // 4
let e: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 5
let f: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 6
let g: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 7
let h: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 8

let aa = Varint.encode(a)
let bb = Varint.encode(b)
let cc = Varint.encode(c)
let dd = Varint.encode(d)
let ee = Varint.encode(e)
let ff = Varint.encode(f)
let gg = Varint.encode(g)
let hh = Varint.encode(h)

print(hh)
