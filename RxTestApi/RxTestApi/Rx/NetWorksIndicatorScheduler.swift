//
//  NetWorksIndicatorScheduler.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import UIKit

/// 网络活动指示器
public final class NetWorksIndicatorScheduler {
    
    public static let shared = NetWorksIndicatorScheduler()
    
    private init(){}
    
    private var _activityCount: Int = 0
    
    private lazy var _activityQueue = DispatchQueue(label: "ActivityIndicatorQueue")
    
    /// 加载网络活动指示器
    public func pushActivityIndicator() {
        _activityQueue.sync { [weak self] in
            guard let self = self else { return }
            self._activityCount += 1
            self._updateActivityIndicator()
        }
    }
    
    public func popActivityIndicator() {
        _activityQueue.sync { [weak self] in
            guard let self = self else { return }
            self._activityCount -= 1
            if self._activityCount < 0 {
                self._activityCount = 0
            }
            self._updateActivityIndicator()
        }
    }
    
    /// 更新状态
    private func _updateActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self._activityCount > 0
        }
    }
    
}

