//
//  ServerApi.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import Moya

public enum ServerApi {
    ///获取通知公告
    case getNoticeList(pageIndex: Int, pageSize: Int)
}

/// 实现协议方法
extension ServerApi: TargetType {
    public var baseURL: URL {
        #if DEVELOP
        return URL(string: "http://test.api.chuanjiapu.cn")!
        #elseif PREVIEW
        return URL(string: "http://test.api.chuanjiapu.cn")!
        #else
        return URL(string: "http://test.api.chuanjiapu.cn")!
        #endif
    }
    /// 路径拼接
    public var path: String {
        switch self {
        case .getNoticeList:
            return "api/index/platform/notice"
        }
    }
    ///请求方式
    public var method: Method {
        switch self {
//        case .getNews:
//            return .post
        case .getNoticeList:
            return .get
        }
    }
    ///编码格式
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    /// 请求任务
    public var task: Task {
        switch self {
        case .getNoticeList(let pageIndex, let pageSize):
            let param: [String: Any] = [
                "pageIndex":pageIndex,
                "pageSize":pageSize
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }
    
    /// heder 可根据不同的接口设置不通的header
    public var headers: [String : String]? {
        return nil
    }
    
}


