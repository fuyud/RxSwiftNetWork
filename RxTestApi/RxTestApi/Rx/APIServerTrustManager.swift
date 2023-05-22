//
//  APIServerTrustManager.swift
//  ClanGenealogy
//
//  Created by Company on 2023/5/19.
//

import UIKit
import Alamofire

public final class APIServerTrustManager: ServerTrustManager {
    init() {
        let allHostsMustBeEvaluated = false
        let evaluators = ["": DisabledTrustEvaluator()]
        super.init(allHostsMustBeEvaluated: allHostsMustBeEvaluated, evaluators: evaluators)
    }
}

