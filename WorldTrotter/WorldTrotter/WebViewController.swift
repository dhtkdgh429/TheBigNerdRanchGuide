//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Oh Sangho on 17/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://www.bignerdranch.com"
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
        
    }
    

}
