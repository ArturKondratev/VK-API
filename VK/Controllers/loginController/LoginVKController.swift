//
//  LoginVKController.swift
//  VK
//
//  Created by Артур Кондратьев on 15.01.2022.
//

import UIKit
import WebKit

class LoginVKController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    var session = Session.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuth()
    }
}

private extension LoginVKController {
    func loadAuth() {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "8051703"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,audio,video,stories,pages,status,wall,groups,email,offline"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
}

extension LoginVKController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String:String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }

        if let token = params["access_token"], let userId = params["user_id"] {
            session.token = token
            session.userId = Int(userId)!
//            print(token)
//            print(userId)
            decisionHandler(.cancel)
            performSegue(withIdentifier: "login", sender: self)
        }
    }
}
