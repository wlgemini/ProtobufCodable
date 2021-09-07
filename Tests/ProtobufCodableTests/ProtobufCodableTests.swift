
import XCTest
@testable import ProtobufCodable



class ProtobufCodableTests: XCTestCase {
    
}


extension ProtobufCodableTests {
    
    func testBinaryInteger() {
        // leadingNonZeroBitIndex
        let leadingNonZeroBitIndex3: UInt16 = 0b0000_0000_0000_1000 // index = 3
        let leadingNonZeroBitIndex7: UInt16 = 0b0000_0000_1000_1000 // index = 7
        let leadingNonZeroBitIndex11: UInt16 = 0b0000_1000_1000_1000 // index = 11
        XCTAssert(leadingNonZeroBitIndex3.leadingNonZeroBitIndex == 3)
        XCTAssert(leadingNonZeroBitIndex7.leadingNonZeroBitIndex == 7)
        XCTAssert(leadingNonZeroBitIndex11.leadingNonZeroBitIndex == 11)
        
        // bit2ByteScalar & byte2BitScalar
        let bit4Scalar: UInt32 = 0b0000_0000_0000_1000
        let bit8Scalar: UInt32 = 0b0000_0000_1111_1111
        let bit12Scalar: UInt32 = 0b0000_1111_1111_1111
        XCTAssert(bit4Scalar.bit2ByteScalar == (bit4Scalar / 8))
        XCTAssert(bit8Scalar.bit2ByteScalar == (bit8Scalar / 8 + 1))
        XCTAssert(bit12Scalar.bit2ByteScalar == (bit12Scalar / 8 + 1))
        
        let byte4Scalar: UInt32 = 0b0000_0000_0000_1000
        let byte8Scalar: UInt32 = 0b0000_0000_1111_1111
        let byte12Scalar: UInt32 = 0b0000_1111_1111_1111
        XCTAssert(byte4Scalar.byte2BitScalar == (byte4Scalar * 8))
        XCTAssert(byte8Scalar.byte2BitScalar == (byte8Scalar * 8))
        XCTAssert(byte12Scalar.byte2BitScalar == (byte12Scalar * 8))
        
        // byte at index
        let byte0: UInt32 = 0b1010_1010
        let byte8: UInt32 = 0b1010_1010_0000_0000
        let byte16: UInt32 = 0b1010_1010_0000_0000_0000_0000
        XCTAssert(byte0.byte(at: 0) == 0b1010_1010)
        XCTAssert(byte8.byte(at: 8) == 0b1010_1010)
        XCTAssert(byte16.byte(at: 16) == 0b1010_1010)
        
        // get bit at index
        let bitGet0: UInt32 = 0b0000_0001
        let bitGet1: UInt32 = 0b0000_0010
        let bitGet2: UInt32 = 0b0000_0100
        let bitGet3: UInt32 = 0b0000_1000
        
        XCTAssert(bitGet0.bit(at: 0) == true)
        XCTAssert(bitGet1.bit(at: 1) == true)
        XCTAssert(bitGet2.bit(at: 2) == true)
        XCTAssert(bitGet3.bit(at: 3) == true)

        // set bit true at index
        var bitSetTrue0: UInt32 = 0b0000_0000
        var bitSetTrue3: UInt32 = 0b0000_0000
        var bitSetTrue4: UInt32 = 0b0001_0000
        var bitSetTrue7: UInt32 = 0b1000_0000
        
        bitSetTrue0.bitTrue(at: 0)
        bitSetTrue3.bitTrue(at: 3)
        bitSetTrue4.bitTrue(at: 4)
        bitSetTrue7.bitTrue(at: 7)
        
        XCTAssert(bitSetTrue0 == 0b0000_0001)
        XCTAssert(bitSetTrue3 == 0b0000_1000)
        XCTAssert(bitSetTrue4 == 0b0001_0000)
        XCTAssert(bitSetTrue7 == 0b1000_0000)
        
        // set bit false at index
        var bitSetFalse0: UInt32 = 0b0000_0000
        var bitSetFalse3: UInt32 = 0b0000_0000
        var bitSetFalse4: UInt32 = 0b0001_0000
        var bitSetFalse7: UInt32 = 0b1000_0000
        
        bitSetFalse0.bitFalse(at: 0)
        bitSetFalse3.bitFalse(at: 3)
        bitSetFalse4.bitFalse(at: 4)
        bitSetFalse7.bitFalse(at: 7)
        
        XCTAssert(bitSetFalse0 == 0b0000_0000)
        XCTAssert(bitSetFalse3 == 0b0000_0000)
        XCTAssert(bitSetFalse4 == 0b0000_0000)
        XCTAssert(bitSetFalse7 == 0b0000_0000)
        
        // set bit toggle at index
        var bitToggle0: UInt32 = 0b0000_0000
        var bitToggle3: UInt32 = 0b0000_0000
        var bitToggle4: UInt32 = 0b0001_0000
        var bitToggle7: UInt32 = 0b1000_0000
        
        bitToggle0.bitToggle(at: 0)
        bitToggle3.bitToggle(at: 3)
        bitToggle4.bitToggle(at: 4)
        bitToggle7.bitToggle(at: 7)
        
        XCTAssert(bitToggle0 == 0b0000_0001)
        XCTAssert(bitToggle3 == 0b0000_1000)
        XCTAssert(bitToggle4 == 0b0000_0000)
        XCTAssert(bitToggle7 == 0b0000_0000)
    }
    
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
