

func zigzagEncode(val: Int64) -> UInt64 {
    UInt64((val << 1) ^ (val >> 63))
}

func zigzagDecode(val: UInt64) -> Int64 {
    let a = Int64(val >> 1)
    let b = -Int64(val & 1)
    return Int64(a ^ b)
}

let a: Int64 = 123
let b: Int64 = -123

let aa = zigzagEncode(val: a)
let bb = zigzagEncode(val: b)

let aaa = zigzagDecode(val: aa)
let bbb = zigzagDecode(val: bb)
