//
//  supportViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/23/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import WebKit
class supportViewController: UIViewController, WKNavigationDelegate, WKUIDelegate{
    
    
    @IBOutlet weak var webview: WKWebView!
    
    var activityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Report Bug/FeedBack"
        
        let url = URL(string: "https://forms.gle/1zMQLjEE4rifPDhz8")
        let request = URLRequest(url: url!)
        
        
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        
        webview.load(request)
        // Do any additional setup after loading the view.
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
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        activityIndicator.center = CGPoint(x: w / 2, y: h / 2)
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    func loadingEnd(){
        activityIndicator.stopAnimating()
        
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
