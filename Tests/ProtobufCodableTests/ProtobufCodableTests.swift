
import XCTest
@testable import ProtobufCodable



class ProtobufCodableTests: XCTestCase {
    
}


extension ProtobufCodableTests {
    
    func testVarint() {
        let v0: UInt64 = 0b0000_0000 // 0
        let v1: UInt64 = 0b0000_0001 // 1
        let v2: UInt64 = 0b0000_0001_0000_0001 // 2
        let v3: UInt64 = 0b0000_0001_0000_0001_0000_0001 // 3
        let v4: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001 // 4
        let v5: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 5
        let v6: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 6
        let v7: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 7
        let v8: UInt64 = 0b0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001_0000_0001 // 8
        let v8Full: UInt64 = 0b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111 // 8

        let e0 = Varint.encode(v0)
        let e1 = Varint.encode(v1)
        let e2 = Varint.encode(v2)
        let e3 = Varint.encode(v3)
        let e4 = Varint.encode(v4)
        let e5 = Varint.encode(v5)
        let e6 = Varint.encode(v6)
        let e7 = Varint.encode(v7)
        let e8 = Varint.encode(v8)
        let e8Full = Varint.encode(v8Full)

        let d0: Varint.Decode<UInt64> = Varint.decode(varint: e0)
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

        XCTAssert(d0.value == e0.value)
        XCTAssert(d1.value == e1.value)
        XCTAssert(d2.value == e2.value)
        XCTAssert(d3.value == e3.value)
        XCTAssert(d4.value == e4.value)
        XCTAssert(d5.value == e5.value)
        XCTAssert(d6.value == e6.value)
        XCTAssert(d7.value == e7.value)
        XCTAssert(d8.value == e8.value)
        XCTAssert(d8Full.value == e8Full.value)
        XCTAssert(d8Trun.value != e8.value)

        print("e0", e0)
        print("e1", e1)
        print("e2", e2)
        print("e3", e3)
        print("e4", e4)
        print("e5", e5)
        print("e6", e6)
        print("e7", e7)
        print("e8", e8)
        print("e8Full", e8Full)

        print("d0", d0)
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
    }
    
    func testZigZag() {
        let p0: Int64 = 0b0000_0001 << 0
        let p4: Int64 = 0b0000_0001 << 4
        let p8: Int64 = 0b0000_0001 << 8

        let n0: Int64 = -(0b0000_0001 << 0)
        let n4: Int64 = -(0b0000_0001 << 4)
        let n8: Int64 = -(0b0000_0001 << 8)


        let ep0: UInt64 = p0.zigzagEncode()
        let ep4: UInt64 = p4.zigzagEncode()
        let ep8: UInt64 = p8.zigzagEncode()

        let en0: UInt64 = n0.zigzagEncode()
        let en4: UInt64 = n4.zigzagEncode()
        let en8: UInt64 = n8.zigzagEncode()

        
        let dp0: Int64 = ep0.zigzagDecode()
        let dp4: Int64 = ep4.zigzagDecode()
        let dp8: Int64 = ep8.zigzagDecode()

        let dn0: Int64 = en0.zigzagDecode()
        let dn4: Int64 = en4.zigzagDecode()
        let dn8: Int64 = en8.zigzagDecode()


        XCTAssert(p0 == dp0)
        XCTAssert(p4 == dp4)
        XCTAssert(p8 == dp8)

        XCTAssert(n0 == dn0)
        XCTAssert(n4 == dn4)
        XCTAssert(n8 == dn8)
    }
    
    func testZigZag_Varint() {
        let p0: Int64 = 0b0000_0001 << 0
        let p4: Int64 = 0b0000_0001 << 4
        let p8: Int64 = 0b0000_0001 << 8

        let n0: Int64 = -(0b0000_0001 << 0)
        let n4: Int64 = -(0b0000_0001 << 4)
        let n8: Int64 = -(0b0000_0001 << 8)


        let ep0: UInt64 = p0.zigzagEncode()
        let ep4: UInt64 = p4.zigzagEncode()
        let ep8: UInt64 = p8.zigzagEncode()

        let en0: UInt64 = n0.zigzagEncode()
        let en4: UInt64 = n4.zigzagEncode()
        let en8: UInt64 = n8.zigzagEncode()


        let veep0 = Varint.encode(ep0)
        let veep4 = Varint.encode(ep4)
        let veep8 = Varint.encode(ep8)

        let veen0 = Varint.encode(en0)
        let veen4 = Varint.encode(en4)
        let veen8 = Varint.encode(en8)


        let vdep0: Varint.Decode<UInt64> = Varint.decode(varint: veep0)
        let vdep4: Varint.Decode<UInt64> = Varint.decode(varint: veep4)
        let vdep8: Varint.Decode<UInt64> = Varint.decode(varint: veep8)

        let vden0: Varint.Decode<UInt64> = Varint.decode(varint: veen0)
        let vden4: Varint.Decode<UInt64> = Varint.decode(varint: veen4)
        let vden8: Varint.Decode<UInt64> = Varint.decode(varint: veen8)


        let dp0: Int64 = vdep0.value.zigzagDecode()
        let dp4: Int64 = vdep4.value.zigzagDecode()
        let dp8: Int64 = vdep8.value.zigzagDecode()

        let dn0: Int64 = vden0.value.zigzagDecode()
        let dn4: Int64 = vden4.value.zigzagDecode()
        let dn8: Int64 = vden8.value.zigzagDecode()


        XCTAssert(p0 == dp0)
        XCTAssert(p4 == dp4)
        XCTAssert(p8 == dp8)

        XCTAssert(n0 == dn0)
        XCTAssert(n4 == dn4)
        XCTAssert(n8 == dn8)
    }
}
