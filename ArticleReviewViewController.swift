//
//  ArticleReviewViewController.swift
//  OleksiyNewsAPI
//
//  Created by User on 03.04.2021.
//

import Foundation
import UIKit
import WebKit

class ArticleReviewViewController: UIViewController, WKNavigationDelegate {
    private let toSegue1 = "viewWeb"
    private var webView: WKWebView!
    
    public var url1 = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: url1)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

    }
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    

}
