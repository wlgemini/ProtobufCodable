//
//  File.swift
//  
//
//  Created by wangluguang on 2021/9/10.
//

import Foundation

class Decoderrrr: Decoder {
    
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        fatalError()
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}

@propertyWrapper
struct Key: Codable {
    
    var wrappedValue: Int
    
    init(wrappedValue: Int, from decoder: Decoder? = nil) throws {
        print(decoder?.codingPath)
        print(CodingKeys.wrappedValue)
        let c = try decoder?.container(keyedBy: CodingKeys.self)
        self.wrappedValue = try c?.decodeIfPresent(Int.self, forKey: CodingKeys.wrappedValue)
    }
}

struct S: Codable {
    
    @Key
    var a = 1
}
