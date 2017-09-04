/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

struct KeychainCofiguration {
    static let serviceName = "TouchMeIn"
    static let accessGroup:String? = nil
}

class LoginViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    var passwordItems:[KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    let touchMe = TouchIDAuth()
    
    @IBOutlet weak var loginButton:UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var touchIDButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if hasLogin {
            loginButton.setTitle("Login", for: .normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.isHidden = true
        }else{
            loginButton.setTitle("Create", for: .normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.isHidden = false
        }
        
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            usernameTextField.text = storedUsername
        }
        touchIDButton.isHidden = !touchMe.canEvaluatePolicy()
    }
    
    // MARK: - Action for checking username/password
    @IBAction func loginAction(_ sender: AnyObject) {
        guard
            let newAccountName = usernameTextField.text,
            let newPassword = passwordTextField.text,
            !newAccountName.isEmpty && !newPassword.isEmpty else {
                let alertView = UIAlertController.init(title: "Login Problem", message: "Wrong username or password.", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "foiled Again!", style: .default, handler: nil)
                alertView.addAction(okAction);
                present(alertView, animated: true, completion: nil)
                return
        }
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if sender.tag == createLoginButtonTag {
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if !hasLoginKey {
                UserDefaults.standard.setValue(usernameTextField.text, forKey: "username")
            }
            
            do {
                let passwordItem = KeychainPasswordItem.init(service: KeychainCofiguration.serviceName, account:newAccountName, accessGroup: KeychainCofiguration.accessGroup)
                try passwordItem.savePassword(newPassword)
            }catch{
                fatalError("Error updating keychain -\(error)")
            }
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            loginButton.tag = loginButtonTag
            performSegue(withIdentifier: "dismissLogin", sender: self)

        }else if sender.tag == loginButtonTag{
            if checkLogin(username: usernameTextField.text!, password: passwordTextField.text!){
                performSegue(withIdentifier: "dismissLogin", sender: self)
            }else{
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password.",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
                alertView.addAction(okAction)
                present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func touchIDLoginAction(_ sender: UIButton) {
        touchMe.authenticateUser() {message in
            if let message = message{
                let alertView =  UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "Darn!", style:.default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true)
            }else{
                self.performSegue(withIdentifier: "dismissLogin", sender: self)
            }
        }
    }
    
    func checkLogin(username:String,password:String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        
        do {
            let passwordItem = KeychainPasswordItem.init(service: KeychainCofiguration.serviceName, account: username, accessGroup: KeychainCofiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword();
            return password == keychainPassword
        }catch{
            fatalError("Error reading password form keychain - \(error)")
        }
        
        return false
    }
}
