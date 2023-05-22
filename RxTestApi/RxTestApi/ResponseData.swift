//
//  ResponseData.swift
//  RxTestApi
//
//  Created by Company on 2023/5/22.
//

import Foundation

/// 实用泛行实现通用格式
public struct ResponseData<T>: Codable where T: Codable {
    var code: Int = 0
    var success: Bool = false
    var message: String = ""
    var result: T?
    var timestamp: Int = 0
    var isEncrypt: Bool = false
}

struct OrdersModel: Codable {
    var asc: Bool?
    var column: String?
}

struct ResultData: Codable {
    var orders: [OrdersModel]?
    var records: [Post]?
    var pages, size, total: Int?
}

public struct Post: Codable {
    var id: Int?
    var createTime: String?
    var subtitle: String?
    var title: String?
    var url: String?
}

