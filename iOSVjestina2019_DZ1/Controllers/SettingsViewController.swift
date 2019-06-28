//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Ivan Cvitanovic on 26/06/2019.
//  Copyright © 2019 Ivan Cvitanovic. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        self.usernameLabel.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        self.usernameTextLabel.backgroundColor = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        self.usernameLabel.textColor = UIColor.white
        self.usernameTextLabel.textColor = UIColor.white
        
        self.usernameTextLabel.text = AuthService().getUsername()
        // Do any additional setup after loading the view.
    }

    @IBAction func logoutTapped(_ sender: UIButton) {
        AuthService().logout()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.showLogin()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
