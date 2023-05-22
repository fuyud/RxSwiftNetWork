//
//  APIRequestInterceptor.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import UIKit
import Alamofire

/// 对request在发出前进行特殊处理
public struct APIRequestInterceptor: RequestInterceptor {
    private let _prepare: ((URLRequest) -> URLRequest)?
    private let _willSend: ((URLRequest) -> Void)?
    
    init(prepare: ((URLRequest) -> URLRequest)? = nil, willSend:((URLRequest) -> Void)? = nil) {
        _prepare = prepare
        _willSend = willSend
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        var request = _prepare?(urlRequest) ?? urlRequest
        request.setValue("iphoneX", forHTTPHeaderField: "User-Agent")
        request.setValue("ios", forHTTPHeaderField: "client-type")
        _willSend?(request)
        completion(.success(request))
    }
}

