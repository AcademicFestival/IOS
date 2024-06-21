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

final class CreateDocumentViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let formViewModel = FormViewModel()
    var formId : String
    init(formId : String){
        self.formId = formId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let textView : UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.backgroundColor = .white
        view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
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
    }
}
//MARK: - UI Layout
private extension CreateDocumentViewController {
    private func setLayout() {
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - Binding
private extension CreateDocumentViewController {
    private func setBinding() {
        formViewModel.getFormTrigger.onNext((self.formId))
        formViewModel.getFormResult.subscribe(onNext: {[weak self] formResult in
            guard let self = self else {return}
            self.textView.text = formResult.first
        }).disposed(by: disposeBag)
    }
    private func BindView() {
        
    }
}
//MARK: - UI Action
private extension CreateDocumentViewController {
    
}
