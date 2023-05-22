//
//  APIProvider.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import UIKit
import Moya
import RxSwift
import PromiseKit

/// 服务器网络请求
public struct APIProvider<Target: TargetType> {
    
    private let _disposeBag = DisposeBag()
    ///定义网络请求发起着
    private let _privider = MoyaProvider<Target>(callbackQueue: .global(), session:{() -> Session in
        
        // 配置特殊网络需求
        let serverTrustManager = APIServerTrustManager()
        let interceptor = APIRequestInterceptor()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15 //设置请求超时时间
        configuration.headers = .default
        return Session(configuration: configuration,
                              interceptor: interceptor,
                              serverTrustManager: serverTrustManager,
                              redirectHandler: nil,
                              cachedResponseHandler: nil,
                              eventMonitors: [])
        
    }(),  plugins: [NetWorksActivityPlugin(),
                    NetWorksLoggerPlugin()])
    
    /// 网络请求
    ///
    /// - Parameters:
    ///   - target: API类型
    ///   - observeOn: 发起请求的Scheduler
    ///   - subscribeOn: 相应请求返回的Scheduler
    ///   - retryCount: 发生错误时重试次数
    /// - Returns: 指定范型的Promise
    public func request<T: Codable>(targetType: Target,
                                    observeOn: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()),
                                    subscribeOn: ImmediateSchedulerType = MainScheduler.instance) -> Promise<T> {
        
        return Promise { seal in
            
            _privider.rx
                .request(targetType, callbackQueue: DispatchQueue.global())
                .observe(on: observeOn).map({
                    try $0._storeServerTimeIntervalDistance()
                        ._catchRandomDomainFlag()
                        ._filterServerSuccessData()
                        ///这里根据自己需要，可直接转成模型，或者使用mapJson,或mapString
                        .map(T.self)
                })
                .subscribe(on: subscribeOn)
                .subscribe(onSuccess: {
                    seal.fulfill($0)
                }, onFailure: { (error) in
                    seal.reject(error)
                })
                .disposed(by: _disposeBag)
        }
    }
}

extension Response {
    
    /// 根据http返回 校准服务器时间
    fileprivate func _storeServerTimeIntervalDistance() throws -> Response {
        guard let serverTime = response?.allHeaderFields["Date"] as? String else {
            return self
        }
        
//        let dateFormatter = DateFormatter().then {
//            $0.locale = Locale(identifier: "en_US_POSIX")
//            $0.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
//        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        if let serverDate = dateFormatter.date(from: serverTime) { // 此处无需时区处理
            let timeIntervalDistance = Date().timeIntervalSince1970 - serverDate.timeIntervalSince1970
            print("请求时间差: \(timeIntervalDistance)")
//            SystemDataManager.shared.preinfoManager.timeIntervalDistance = timeIntervalDistance
        }
        
        return self
    }
    
    /// 根据http返回 处理特殊逻辑 如切换域名
    fileprivate func _catchRandomDomainFlag() -> Response {
        if [410, 420, 500, 510, 511, 512, 515].contains(statusCode) { // 有错误可以抛特殊异常 用与retry
            print("http 错误码: \(statusCode)")
        }
        return self
    }
    
    /// 服务器返回数据格式错误
    fileprivate func _filterServerSuccessData() throws -> Response {
        do {
            let responseJson = try mapJSON(failsOnEmptyData: false)
            guard let dict = responseJson as? [String: Any] else { throw APIError.parseJsonError }
            if let error = _praseServerError(dict: dict) { throw error }
            return self
        } catch {
            throw error
        }
    }
    
    /// 服务器自定义错误
    private func _praseServerError(dict: [String: Any]) -> Error? {
        guard let code = dict["code"] as? Int else { //跟自己服务器约定的返回值字段
            return APIError.parseStatusCodeTypeError
        }
        
        let message = dict["message"] as? String //跟服务器约定的message字段
        guard code == 200 else { // 有错误,根据与服务器约定code判断
            return APIError.serverDefineError(code: code,
                                              message: message ?? "服务器返回 returnCode：\(code)")
        }
        
        return nil
    }
    
}


