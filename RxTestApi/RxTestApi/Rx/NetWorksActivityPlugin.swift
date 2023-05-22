//
//  NetWorksActivityPlugin.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import UIKit
import Moya

/// 网络活动状态观察
public final class NetWorksActivityPlugin: PluginType {
    
    /// 将要发送的时候开启
    public func willSend(_ request: RequestType, target: TargetType) {
        NetWorksIndicatorScheduler.shared.pushActivityIndicator()
    }
    
    /// 数据返回关闭
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        NetWorksIndicatorScheduler.shared.popActivityIndicator()
    }
}


