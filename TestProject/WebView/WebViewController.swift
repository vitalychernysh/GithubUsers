//
//  WebViewController.swift
//  TestProject
//
//  Created by Vitalii Chernysh on 13.11.2023.
//

import UIKit
import WebKit
import SnapKit

final class WebViewController: UIViewController {
    
    private let webView = WKWebView()
    private let url: URL
    
    init(url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: Bundle.main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
    }

    private func setupWebView() {
        webView.load(URLRequest(url: url))

        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
