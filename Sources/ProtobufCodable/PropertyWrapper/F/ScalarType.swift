
public protocol ScalarType {
    
    associatedtype T
    
    static var `default`: T { get }
}

//
//extension Swift.Double: ScalarType {
//
//    public static var `default`: Double { 0 }
//}
//
//extension Swift.Float: ScalarType {
//    
//    public static var `default`: Float { 0 }
//}
//
//extension Swift.UInt32: ScalarType {
//
//    public static var `default`: UInt32 { 0 }
//}
//
//extension Swift.UInt64: ScalarType {
//
//    public static var `default`: UInt64 { 0 }
//}
//
//extension Swift.Int32: ScalarType {
//
//    public static var `default`: Int32 { 0 }
//}
//
//extension Swift.Bool: ScalarType {
//
//    public static var `default`: Bool { false }
//}

/*
extension Swift.String: ScalarType {
    
    public static var `default`: String { "" }
}

extension Swift.Array: ScalarType where Element == UInt8 {
    
    public static var `default`: [UInt8] { [] }
}
 */
