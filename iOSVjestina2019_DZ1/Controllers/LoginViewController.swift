//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 19/05/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appTitle: UILabel!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AuthService()
        self.view.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 3
        
        loginButton.snp.makeConstraints({(make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
        })
        
        usernameTextField.transform = CGAffineTransform(translationX: -usernameTextField.frame.size.width - usernameTextField.frame.origin.x, y: 0)
        usernameTextField.alpha = 0
        
        passwordTextField.transform = CGAffineTransform(translationX: -passwordTextField.frame.size.width - passwordTextField.frame.origin.x, y: 0)
        passwordTextField.alpha = 0
        
        loginButton.transform = CGAffineTransform(translationX: -loginButton.frame.size.width - loginButton.frame.origin.x, y: 0)
        loginButton.alpha = 0
        
        appTitle.transform = CGAffineTransform(scaleX: 0, y: 0)
        appTitle.alpha = 0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        if(authService.isAuthenticated()){
            openQuizzesList()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        animateIn()
    }
    
    func animateIn(){
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.usernameTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.usernameTextField.alpha = 1
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.35, delay: 0.1, options: [.curveEaseInOut], animations: {
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.passwordTextField.alpha = 1
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.35, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.loginButton.alpha = 1
            self.appTitle.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.appTitle.alpha = 1
        }) { _ in
        }
    }
    
    func animateOut(completion: @escaping ((Bool) -> Void)){
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.appTitle.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.appTitle.alpha = 0
            self.usernameTextField.transform = CGAffineTransform(translationX: 0, y: -100)
            self.usernameTextField.alpha = 0
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.35, delay: 0.1, options: [.curveEaseInOut], animations: {
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: -100)
            self.passwordTextField.alpha = 0
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.35, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: -100)
            self.loginButton.alpha = 0
        }, completion: {(finished:Bool) in
            completion(finished)
        })
    }
    
    @objc func login(sender: UIButton!) {
        
        authService.login(username: usernameTextField.text!, password: passwordTextField.text!){[weak self] (authToken) in
            if(authToken != nil){
                self?.authService.saveLoginToken(authToken: authToken!)
                self?.authService.saveUserId(authToken: authToken!)
                DispatchQueue.main.async {
                    if let username = self?.usernameTextField.text{
                        self?.authService.saveUsername(username: username)
                    }
                    self?.DismissKeyboard()
                    self?.animateOut(){ [weak self] (finished) in
                        if(finished == true){
                            self?.openQuizzesList()
                        }
                    }
                }
            }
        }
    }
    
    func openQuizzesList(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.hideLogin()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let loginButtonBottomPosition = self.loginButton.frame.origin.y + self.loginButton.frame.height
            if endFrameY >= loginButtonBottomPosition {
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            } else {
                if let endFrame = endFrame{
                    let keyboardTopPosition = self.view.frame.height - endFrame.size.height
                    self.view.transform = CGAffineTransform(translationX: 0, y: -(loginButtonBottomPosition - keyboardTopPosition + 20))
                }
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func DismissKeyboard(){
        //Causes the view to resign from the status of first responder.
        self.view.endEditing(true)
    }

}
