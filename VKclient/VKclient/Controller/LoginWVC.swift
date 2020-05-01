//
//  LoginWebViewController.swift
//  VKclient
//
//  Created by Станислав Буйновский on 15.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import WebKit

class LoginWVC: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SessionData.shared.token != "" {
            performSegue(withIdentifier: "ShowTabBarController", sender: AnyObject.self)
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        
        components.queryItems = [
        URLQueryItem(name: "client_id", value: "7359889"),
        URLQueryItem(name: "display", value: "mobile"),
        URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
        URLQueryItem(name: "scope", value: "users,friends,groups,photos,wall"),
        URLQueryItem(name: "response_type", value: "token"),
        URLQueryItem(name: "v", value: "5.103"),
        ]
        
        let request = URLRequest(url: components.url!)
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if SessionData.shared.token != "" {
            return true
        } else {
            print("Empty token")
            return false
        }
        
    }
}


extension LoginWVC: WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { (result, param) in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        SessionData.shared.token = params["access_token"]!
        print("TOKEN: \(SessionData.shared.token)")
        decisionHandler(.cancel)
        performSegue(withIdentifier: "ToTabBarController", sender: AnyObject.self)
    }
    
}

