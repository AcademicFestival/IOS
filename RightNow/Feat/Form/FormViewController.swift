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
    private let formViewModel = FormViewModel()
    
    //MARK: - UI Components
    private let createFormButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setTitle("Create Form", for: .normal)
        return button
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
private extension FormViewController {
    private func setNavigation() {
        self.title = ""
        self.view.backgroundColor = .white
    }
}
//MARK: - UI Layout
private extension FormViewController {
    private func setLayout() {
        self.view.addSubview(createFormButton)
        self.view.addSubview(loadingIndicator)
        createFormButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.center.equalToSuperview()
            make.height.equalTo(50)
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
        formViewModel.createFormResult.subscribe(onNext: {[weak self] formData in
            guard let self = self else {return}
            self.loadingIndicator.stopAnimating()
            self.navigationController?.pushViewController(WebViewController(formData: formData), animated: true)
        }).disposed(by: disposeBag)
    }
    private func BindView() {
        
    }
}
//MARK: - UI Action
private extension FormViewController {
    
}
