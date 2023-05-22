//
//  ViewController.swift
//  RxTestApi
//
//  Created by Company on 2023/5/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 20, y: 300, width: self.view.bounds.size.width - 20 * 2, height: 40)
    }
    
    @objc func buttonAction(button: UIButton) {
        NetWorkManager.shared.request(type: ResultData.self, serverApi: .getNoticeList(pageIndex: 1, pageSize: 10)) { response in
            print(response)
        } failureHandler: { error in
            print(error)
        }

    }

    //MARK: --- lazy ---
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("请求按钮", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonAction(button: )), for: .touchUpInside)
        return button
    }()
}

