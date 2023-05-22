//
//  NetWorhManager.swift
//  RxTestApi
//
//  Created by Company on 2023/5/22.
//

import UIKit
import RxSwift
import PromiseKit
import Moya

typealias ErrorCallback = ((_ error: NSError) -> Void)

typealias SuccessCallback<T: Codable> = ((_ response: ResponseData<T>) -> Void)

class NetWorkManager: NSObject {
    
    static let shared: NetWorkManager = NetWorkManager()
    
    private let _provide = APIProvider<ServerApi>()
    
    func request<T: Codable>(type: T.Type, serverApi: ServerApi, successHandler: @escaping SuccessCallback<T>, failureHandler: ErrorCallback?) {
        let requestPromis: Promise<ResponseData<T>> = _provide.request(targetType: serverApi)
        requestPromis.ensure {
            //请求完成前
            }.done { (result) in
                //请求完成
//                print("请求成功回调：",result,result.message)
                successHandler(result)
            }.catch { (error) in
                //错误处理
                print("请求失败回调：",error)
                failureHandler?(error as NSError)
            }
    }
    
}
