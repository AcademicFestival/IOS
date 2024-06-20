//
//  WebViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/20.
//

import UIKit
import WebKit

final class WebViewController : UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var loadingIndicator: UIActivityIndicatorView!
    let url : String
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        // 웹 뷰 생성
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        webView.contentMode = .scaleAspectFit
        self.view.addSubview(webView)
        webView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        // 로딩 인디케이터 생성
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        if let url = URL(string: self.url){
            // 웹 페이지를 로드하기 전에 로딩 화면 표시
            loadingIndicator.startAnimating()
            // 웹 페이지를 로드
            let request = URLRequest(url:url)
            webView.load(request)
        }
    }
    // 웹 페이지 로딩이 시작될 때 호출되는 메서드
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 로딩 화면 표시
        loadingIndicator.startAnimating()
    }
    // 웹 페이지 로딩이 종료될 때 호출되는 메서드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 로딩 화면 숨김
        loadingIndicator.stopAnimating()
    }
}
