//
//  BinaryDecoder.swift
//  
//
//  Created by wangluguang on 2021/8/4.
//


public final class BinaryDecoder: Decoder {
    
    public var codingPath: [CodingKey] = []
    
    public var userInfo: [CodingUserInfoKey : Any]
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        
    }
    
    public init() {}

    public func decode<T>(_ type: T.Type, from data: [UInt8]) throws -> T where T : Decodable {
        
    }
}
