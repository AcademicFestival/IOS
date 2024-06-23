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
import Kingfisher
import Foundation
import NVActivityIndicatorView

final class FormViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let formViewModel = FormViewModel()
    var question : String
    init(question: String) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "서류분석 완료!"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let decLabel : UITextView = {
        let label = UITextView()
        label.text = "서류를 토대로 질문 생성 중입니다.\n생성이 완료되면 자동으로 페이지가 넘어갑니다."
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let image : AnimatedImageView = {
        let view = AnimatedImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    //진행바
    private let progress : UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.tintColor = .systemGreen
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
        self.view.addSubview(titleLabel)
        self.view.addSubview(decLabel)
        self.view.addSubview(image)
        self.view.addSubview(progress)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(self.view.frame.height / 10)
        }
        decLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        image.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(0)
            make.top.equalTo(decLabel.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(30)
            make.height.equalToSuperview().dividedBy(3)
            make.center.equalToSuperview()
        }
        progress.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(20)
            make.top.equalTo(image.snp.bottom).offset(50)
        }
        if let gifUrl = Bundle.main.url(forResource: "confetti", withExtension: "gif") {
            image.kf.setImage(with: gifUrl)
        }
        updateProgress()
    }
    private func updateProgress() {
        guard self.progress.progress < 1.0 else { return }
        self.progress.progress += 0.01
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.updateProgress()
        }
    }
}
//MARK: - Binding
private extension FormViewController {
    private func setBinding() {
        BindView()
        self.formViewModel.createFormTrigger.onNext((self.question))
        formViewModel.createFormResult.subscribe(onNext: {[weak self] formData in
            guard let self = self else {return}
            self.navigationController?.pushViewController(WebViewController(formData: formData), animated: true)
        }).disposed(by: disposeBag)
    }
    private func BindView() {
        
    }
}
//MARK: - UI Action
private extension FormViewController {
    
}
