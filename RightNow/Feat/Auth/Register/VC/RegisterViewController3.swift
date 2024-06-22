//
//  RegisterViewController3.swift
//  EntrepreneurshipApp
//
//  Created by 정성윤 on 2024/06/16.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

final class RegisterViewController3 : UIViewController{
    private let disposeBag = DisposeBag()
    private let registerViewModel = RegisterViewModel()
    private var essentialBtnBool : Bool = false
    private var selectiveBtnBool : Bool = false
    //MARK: - UI Components
    //회원유형
    private let agreeTitle : UILabel = {
        let label = UILabel()
        label.text = "약관 동의"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    //필수 동의
    private let essentialView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let essentialLabel : UILabel = {
        let label = UILabel()
        label.text = "필수 동의"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let essentialSpacing : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private lazy var essentialBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(essentialBtnTapped), for: .touchUpInside)
        return btn
    }()
    //서비스 이용약관 동의
    private let serviceEssentialBtn : UIButton = {
        let btn = UIButton()
        var configuration = UIButton.Configuration.borderless()
        configuration.attributedTitle = AttributedString("서비스 이용 약관 동의", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.lightGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        btn.backgroundColor = .white
        btn.configuration = configuration
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    //개인정보 수집 이용 동의
    private let collectionBtn : UIButton = {
        let btn = UIButton()
        var configuration = UIButton.Configuration.borderless()
        configuration.attributedTitle = AttributedString("개인정보 수집 이용 동의", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.lightGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        btn.backgroundColor = .white
        btn.configuration = configuration
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    //선택 동의
    private let selectiveView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let selectiveLabel : UILabel = {
        let label = UILabel()
        label.text = "선택 동의"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private lazy var selectiveBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(selectiveBtnTapped), for: .touchUpInside)
        return btn
    }()
    private let selectiveSpacing : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    //이벤트 정보 수신 동의 -> 다른 동의 대체
    private let receptionBtn : UIButton = {
        let btn = UIButton()
        var configuration = UIButton.Configuration.borderless()
        configuration.attributedTitle = AttributedString("이벤트 정보 수신 동의", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.lightGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        btn.backgroundColor = .white
        btn.configuration = configuration
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    //다음 버튼
    private lazy var nextBtn : UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.backgroundColor = .gray
        btn.setTitle("회원가입", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        btn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setLayout()
        setBinding()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
//MARK: - UI Naviagtion
private extension RegisterViewController3 {
    private func setNavigation() {
        self.title = "회원가입"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
}

//MARK: - UI Layout
private extension RegisterViewController3 {
    private func setLayout() {
        self.view.addSubview(agreeTitle)
        //필수 동의
        essentialView.addSubview(essentialLabel)
        essentialView.addSubview(essentialBtn)
        essentialView.addSubview(essentialSpacing)
        essentialView.addSubview(serviceEssentialBtn)
        essentialView.addSubview(collectionBtn)
        self.view.addSubview(essentialView)
        //선택 동의
        selectiveView.addSubview(selectiveLabel)
        selectiveView.addSubview(selectiveBtn)
        selectiveView.addSubview(selectiveSpacing)
        selectiveView.addSubview(receptionBtn)
        self.view.addSubview(selectiveView)
        self.view.addSubview(nextBtn)
        
        agreeTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(22)
            make.top.equalTo(144)
        }
        //필수 동의
        essentialLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(1.5)
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        essentialBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(essentialLabel.snp.top).offset(5)
            make.width.height.equalTo(15)
        }
        essentialSpacing.snp.makeConstraints { make in
            make.top.equalTo(essentialBtn.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0.5)
        }
        serviceEssentialBtn.snp.makeConstraints { make in
            make.top.equalTo(essentialSpacing.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(22)
        }
        collectionBtn.snp.makeConstraints { make in
            make.top.equalTo(serviceEssentialBtn.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(22)
        }
        essentialView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(agreeTitle.snp.bottom).offset(10)
            make.height.equalTo(123)
        }
        //선택 동의
        selectiveLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(1.5)
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        selectiveBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(selectiveLabel.snp.top).offset(5)
            make.width.height.equalTo(15)
        }
        selectiveSpacing.snp.makeConstraints { make in
            make.top.equalTo(selectiveBtn.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0.5)
        }
        receptionBtn.snp.makeConstraints { make in
            make.top.equalTo(selectiveSpacing.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(22)
        }
        selectiveView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(essentialView.snp.bottom).offset(20)
            make.height.equalTo(91)
        }
        nextBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
}
//MARK: - Binding
private extension RegisterViewController3 {
    private func setBinding(){
        BindView()
    }
    private func BindView() {
        
    }
}
//MARK: - UI Action
extension RegisterViewController3{
    @objc private func essentialBtnTapped() {
        if essentialBtnBool == true {
            essentialBtn.backgroundColor = .white
            nextBtn.backgroundColor = .gray
            nextBtn.isEnabled = false
            essentialBtnBool = false
        }else{
            essentialBtn.backgroundColor = .black
            nextBtn.backgroundColor = .pointColor
            nextBtn.isEnabled = true
            essentialBtnBool = true
        }
    }
    @objc private func selectiveBtnTapped() {
        if selectiveBtnBool == true {
            selectiveBtn.backgroundColor = .white
            selectiveBtnBool = false
        }else{
            selectiveBtn.backgroundColor = .black
            selectiveBtnBool = true
        }
    }
    @objc private func nextBtnTapped() {
//        self.navigationController?.pushViewController(, animated: true)
    }
    private func showAlert(title : String, message : String) {
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "확인", style: .default)
        Alert.addAction(Ok)
        self.present(Alert, animated: true)
    }
}
