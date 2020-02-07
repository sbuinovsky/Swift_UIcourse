//
//  ViewController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 28.01.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShown (notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let size = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let areaInsets = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
        
        self.scrollView?.contentInset = areaInsets
        self.scrollView.scrollIndicatorInsets = areaInsets
        
    }
    
    @objc func keyboardWillHide (notification: Notification) {
        self.scrollView.contentInset = .zero
        
    }
    
    @objc func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
    
    func checkLogin() -> Bool {
        if let login = loginTextField.text,
            let password = passwordTextField.text {
            
            print("Login: \(login) and Password: \(password)")
            
            if login == "user", password == "123" {
                print("Sign in success")
                return true
            } else {
                print("Access denied")
                showLoginError()
                return false
            }
        }
        return false
    }
    
    func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "Неверное сочетания логиина и пароля", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            print("Ok clicked")
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if checkLogin() {
            return true
        } else {
            showLoginError()
            return false
        }
        
    }
    
}

