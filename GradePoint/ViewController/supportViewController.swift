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
        ProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webVIew did finish")
        ProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView did fail")
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
