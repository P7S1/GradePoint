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
    

    @IBOutlet weak var navItem: UINavigationItem!
    
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(exitPressed(_:))
        )
        rightButtonItem.tintColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
        
        self.navItem.title = "Privacy Policy"
        self.navItem.rightBarButtonItem = rightButtonItem
        
        
        let url = URL(string: "https://gradepoint.flycricket.io/privacy.html")
        let request = URLRequest(url: url!)
        
        
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        
        webview.load(request)
    }
   @objc func exitPressed(_ sender: Any) {
        print("exiting privacy policy view controller")
        self.dismiss(animated: true, completion: nil)
    }
  /*  @IBAction func safariPressed(_ sender: Any) {
        print("going to Safari")
        let url = URL(string: "https://www.google.com")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        }
    } */
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
