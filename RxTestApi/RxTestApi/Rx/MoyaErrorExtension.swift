//
//  MoyaErrorExtension.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import UIKit
import Moya

extension MoyaError {
    
    /// MoyaError错误描述
    public var errorMoyaDescription: String {
        switch self {
        case MoyaError.imageMapping:
            return "请求异常 (图片数据解析)."
        case MoyaError.jsonMapping:
            return "请求异常 (Json数据解析)."
        case MoyaError.stringMapping:
            return "请求异常 (字符串数据解析)."
        case MoyaError.objectMapping(let error, _):
            return error.errorDescription
        case MoyaError.encodableMapping:
            return "请求异常 (Encodable Mapping)."
        case MoyaError.statusCode(let response):
            return ("请求失败,请重试! 错误码： " + "(\(response.statusCode))")
        case MoyaError.requestMapping:
            return "请求异常 (Request Mapping)"
        case MoyaError.parameterEncoding(let error):
            return "请求异常 (Parameter Encoding): \(error.errorDescription)"
        case MoyaError.underlying(_, _):
            return "请求异常 (Underlying)"
        }
    }
}


