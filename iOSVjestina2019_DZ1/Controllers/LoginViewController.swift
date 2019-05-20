//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 19/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints({(make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalTo(self.view)
        })
    }
    
    @objc func login(sender: UIButton!) {
        let quizzesVc = QuizzesViewController()
        navigationController?.pushViewController(quizzesVc, animated: false)
    }

}
