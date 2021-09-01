
import Foundation


class _Decoder: Decoder {
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer<Key>(_KeyedDecodingContainer())
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        _UnkeyedDecodingContainer(codingPath: [], count: nil, isAtEnd: false, currentIndex: 0)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        _SingleValueDecodingContainer(codingPath: [])
    }
}


struct _KeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {

    
    var codingPath: [CodingKey] = []

    var allKeys: [Key] = []

    func contains(_ key: Key) -> Bool {
        
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        
    }

    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        
    }

    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        
    }

    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        
    }

   
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        
    }

    func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
        
    }

    func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
        
    }

    func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
        
    }

    func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
        
    }

    func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
        
    }

    func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8? {
        
    }

    func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16? {
        
    }

    
    func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32? {
        
    }

    
    func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64? {
        
    }

    
    func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt? {
        
    }

    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8? {
        
    }

    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16? {
        
    }

    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32? {
        
    }

    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64? {
        
    }

    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T : Decodable {
        
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        
    }

    
    func superDecoder() throws -> Decoder {
        
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        
    }
}







struct _UnkeyedDecodingContainer: UnkeyedDecodingContainer {
    
    var codingPath: [CodingKey]

    var count: Int?

    var isAtEnd: Bool

    var currentIndex: Int

    mutating func decodeNil() throws -> Bool {
        
    }

    
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        
    }

    
    mutating func decode(_ type: String.Type) throws -> String {
        
    }

    mutating func decode(_ type: Double.Type) throws -> Double {
        
    }

    mutating func decode(_ type: Float.Type) throws -> Float {
        
    }


    mutating func decode(_ type: Int.Type) throws -> Int {
        
        
    }


    
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        
    }


    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        
    }

    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        
    }

    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        
    }

    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        
    }

    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        
    }

    
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        
    }

   
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        
    }

    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        
    }

    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        
    }

    
    
    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        
    }

    
    mutating func decodeIfPresent(_ type: String.Type) throws -> String? {
        
    }

    
    mutating func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        
    }

    
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        
    }

    
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        
    }

    
    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        
    }

    
    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        
    }

    
    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        
    }

    
    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        
    }

    
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        
    }

    
    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        
    }

    
    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        
    }

    
    
    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        
    }

    
    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        
    }

    
    mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable {
        
    }

    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey  {
        
    }


    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer  {
        
    }

    
    
    mutating func superDecoder() throws -> Decoder {
        
    }
}






struct _SingleValueDecodingContainer: SingleValueDecodingContainer {
    
    var codingPath: [CodingKey]


    func decodeNil() -> Bool {
        
    }


    
    func decode(_ type: Bool.Type) throws -> Bool {
        
    }


    
    func decode(_ type: String.Type) throws -> String {
        
    }


    
    func decode(_ type: Double.Type) throws -> Double {
        
    }


    
    func decode(_ type: Float.Type) throws -> Float {
        
    }

    
    
    func decode(_ type: Int.Type) throws -> Int {
        
    }

   
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        
    }

  
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        
    }

    
    func decode(_ type: Int32.Type) throws -> Int32 {
        
    }

    
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        
    }

    
    
    func decode(_ type: UInt.Type) throws -> UInt {
        
    }

   
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        
    }


    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        
    }

   
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        
    }

    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        
    }

    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        
    }
}
