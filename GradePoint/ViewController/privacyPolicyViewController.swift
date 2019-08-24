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
        loadingStart()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webVIew did finish")
        loadingEnd()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView did fail")
    }
    func loadingStart(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    func loadingEnd(){
        activityIndicator.stopAnimating()
        
    }
}
