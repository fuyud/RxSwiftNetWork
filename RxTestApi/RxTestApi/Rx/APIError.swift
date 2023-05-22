//
//  APIError.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import UIKit
import Foundation
import Moya

/// 自己服务器错误
public enum APIError: Swift.Error {
    
    /// 解析Json格式错误
    case parseJsonError

    /// 解析服务器定义StatusCode格式错误
    case parseStatusCodeTypeError
    
    /// 服务器自定义错误
    case serverDefineError(code: Int, message: String)
}


extension APIError {
    
    /// 自己服务器错误描述
    public var errorAPIDescription: String {
        switch self {
        case .parseJsonError:
            return "解析Json格式错误"
        case .parseStatusCodeTypeError:
            return "解析服务器定义StatusCode格式错误"
        case .serverDefineError(_, let message): //返回服务器定义的错误信息
            return message
        }
    }
}

extension Swift.Error {
    /// Swift.Error错误描述 兼容所有错误类型的描述
    public var errorDescription: String {
        if let moyaError = self as? MoyaError {
            return moyaError.errorMoyaDescription
        } else if let apiError = self as? APIError {
            return apiError.errorAPIDescription
        }
//        else if let rpError = self as? ResourceProviderError {
//            return rpError.errorRPDescription
//        }
        else {
            return localizedDescription
        }
    }
    
    /// 是否是 Moya被取消的网络请求
    public var isMoyaCancledType: Bool {
        let result: Bool
        
        guard let moyaError = self as? MoyaError else {
            result = false
            return result
        }
        
        switch moyaError {
        case .underlying(let err, _):
            result = (err as NSError).code == -999
        default:
            result = false
        }
        
        return result
    }
}
