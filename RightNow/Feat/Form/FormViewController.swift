//
//  FormViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Foundation
import NVActivityIndicatorView

final class FormViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let formViewModel : FormViewModel
    
    init(formViewModel: FormViewModel) {
        self.formViewModel = formViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let createFormButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("Create Form", for: .normal)
        return button
    }()
    private let getFormButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("Get Form", for: .normal)
        return button
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .ballBeat, color: .pointColor)
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
private extension FormViewController {
    private func setNavigation() {
        self.view.backgroundColor = .white
    }
}
//MARK: - UI Layout
private extension FormViewController {
    private func setLayout() {
        self.view.addSubview(getFormButton)
        self.view.addSubview(createFormButton)
        self.view.addSubview(loadingIndicator)
        
        getFormButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        createFormButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.top.equalTo(getFormButton.snp.bottom).offset(10)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
//MARK: - Binding
private extension FormViewController {
    private func setBinding() {
        BindView()
        createFormButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.formViewModel.createFormTrigger.onNext(())
                self.loadingIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
        formViewModel.createFormResult.subscribe(onNext: {[weak self] url in
            guard let self = self else {return}
            self.loadingIndicator.stopAnimating()
            self.navigationController?.pushViewController(WebViewController(url: url), animated: true)
        }).disposed(by: disposeBag)
        
        
        getFormButton.rx.tap
            .map { "YOUR_FORM_ID" } //실제 폼 ID
            .bind(to: formViewModel.getFormTrigger)
            .disposed(by: disposeBag)
        
//        formViewModel.createFormResult
//            .subscribe(onNext: { form in
//                print("Survey created: \(form)")
//            })
//            .disposed(by: disposeBag)
//
//        formViewModel.getFormResult
//            .subscribe(onNext: { form in
//                print("Survey fetched: \(form)")
//            })
//            .disposed(by: disposeBag)
    }
    private func BindView() {
        
    }
}
//MARK: - UI Action
private extension FormViewController {
    
}
