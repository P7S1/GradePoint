//
//  privacyPolicyViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/4/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import WebKit

class privacyPolicyViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webview: WKWebView!
    
    
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Privacy Policy"
        
        let url = URL(string: "https://gradepoint-0.flycricket.io/privacy.html")
        let request = URLRequest(url: url!)
        
        
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        
        webview.load(request)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView did start")
        ProgressHUD.show()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webVIew did finish")
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView did fail")
    }
}
