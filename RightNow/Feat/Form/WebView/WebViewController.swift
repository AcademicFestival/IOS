//
//  WebViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/20.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit
import NVActivityIndicatorView

final class WebViewController : UIViewController, WKNavigationDelegate{
    private let disposeBag = DisposeBag()
    private let formViewModel = FormViewModel()
    
    let formData : [String]
    init(formData: [String]) {
        self.formData = formData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private var webView : WKWebView = {
        let view = WKWebView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .ballPulse, color: .pointColor)
        view.clipsToBounds = true
        return view
    }()
    private lazy var completeBtn : UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "👉🏻\t완료", style: .plain, target: self, action: #selector(completeBtnTapped))
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigation()
        webViewConnect()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
}
//MARK: - UI Navigation
private extension WebViewController {
    private func setNavigation() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItem = completeBtn
    }
}
//MARK: - UI Layout
extension WebViewController {
    private func setLayout() {
        self.setWebView()
        self.view.addSubview(webView)
        self.view.addSubview(loadingIndicator)
        webView.snp.makeConstraints{ (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    private func setWebView() {
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
    }
}
//MARK: - Connect To WebView
private extension WebViewController {
    private func webViewConnect() {
        if let url = URL(string: self.formData[1]){
            // 웹 페이지를 로드하기 전에 로딩 화면 표시
            loadingIndicator.startAnimating()
            // 웹 페이지를 로드
            let request = URLRequest(url:url)
            webView.load(request)
        }
    }
}
//MARK: - UI Action
private extension WebViewController {
    @objc private func completeBtnTapped() {
        showAlert(title: "답변 확인", message: "질문에 대한 모든 답변을 완료하셨나요?\n입력하신 답변을 기반으로 문서생성이 됩니다.")
    }
    private func showAlert(title: String, message: String) {
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "확인", style: .default){ _ in
//            self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        }
        let Cancel = UIAlertAction(title: "취소", style: .destructive)
        Alert.addAction(Ok)
        Alert.addAction(Cancel)
        self.present(Alert, animated: true)
    }
}
