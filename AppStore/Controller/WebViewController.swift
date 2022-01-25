//
//  WebViewController.swift
//  AppStore
//
//  Created by Лилия on 14.01.2022.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    
    // MARK: - Properties
    
    let webView = WKWebView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        guard let url = URL(string: "https://apps.apple.com/ua/app/%D0%B4%D1%96%D1%8F/id1489717872") else { return }
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - Selectors
    
    @objc private func handleCancel() {
        print("DEBUG: Cancel to..")
        dismiss(animated: true)
    }
    
    
}
