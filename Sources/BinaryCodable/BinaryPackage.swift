//
//  BinaryPackage.swift
//  
//
//  Created by wangluguang on 2021/8/5.
//

import Foundation

/*
 0              4               8               12              16
 |version                       |header length                  |
 |body encoding                 |body length                    |
 +--------------------------------------------------------------+
 |body data                                                     |
 */
struct BinaryPackage<DataDescription> {
        
    /// 版本号
    let version: UInt8
    
    /// 首部长度
    let headerLength: UInt8

    /// 数据描述
    let dataDescription: DataDescription
}


struct DataDescription<Length: UnsignedInteger> {
    
    /// 数据类型
    let type: UInt8
    
    /// 数据长度
    let length: Length
}
