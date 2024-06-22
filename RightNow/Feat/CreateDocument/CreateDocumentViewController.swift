//
//  CreateDocumentViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation
import PDFKit
import NVActivityIndicatorView

final class CreateDocumentViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let formViewModel = FormViewModel()
    private var questions : [String] = []
    var formId : String
    init(formId : String){
        self.formId = formId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private var pdfView : PDFView = {
        let view = PDFView()
        view.clipsToBounds = true
        return view
    }()
    private var fileURL: URL? // 다운로드한 파일의 URL을 저장하기 위한 변수
    private lazy var downloadBtn : UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(downloadBtnTapped))
        return btn
    }()
    private lazy var homeBtn : UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(homeBtnTapped))
        return btn
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .ballPulse, color: .pointColor)
        view.clipsToBounds = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setNavigation()
    }
}
//MARK: - UI Navigation
private extension CreateDocumentViewController {
    private func setNavigation() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItems = [homeBtn, downloadBtn]
    }
}
//MARK: - UI Layout
private extension CreateDocumentViewController {
    private func setLayout() {
        self.view.addSubview(pdfView)
        self.view.addSubview(loadingIndicator)
        pdfView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
            make.leading.trailing.bottom.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
    }
}
//MARK: - Binding
private extension CreateDocumentViewController {
    private func setBinding() {
        let questions = FormViewModel.questionArray
        self.formViewModel.getFormTrigger.onNext((self.formId))
        self.formViewModel.getFormResult.subscribe(onNext: {[weak self] formResult in
            guard let self = self else {return}
            var params : [String:Any] = [:]
            for (index, question) in questions.enumerated() {
                params[question] = formResult[index]
            }
            JsonTodocx.json_to_docx(params: params).subscribe(onNext: {[weak self] fileURL in
                guard let self = self else {return}
                self.fileURL = fileURL
                self.showPDF(file: fileURL)
            }).disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)
    }
    private func BindView() {
        
    }
}
//MARK: - UI Action
private extension CreateDocumentViewController {
    func showPDF(file: URL) {
        // PDFView 설정
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        // PDF 파일 로드
        if let document = PDFDocument(url: file) {
            pdfView.document = document
            self.view.addSubview(pdfView)
            loadingIndicator.stopAnimating()
        } else {
            print("Failed to load PDF document.")
        }
    }
    @objc private func downloadBtnTapped() {
        guard let fileURL = fileURL else {
            print("No file URL to save.")
            return
        }
        
        let documentInteractionController = UIDocumentInteractionController(url: fileURL)
        documentInteractionController.delegate = self
        documentInteractionController.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
    }
    @objc private func homeBtnTapped() {
//        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
}
extension CreateDocumentViewController: UIDocumentInteractionControllerDelegate {
    
}
