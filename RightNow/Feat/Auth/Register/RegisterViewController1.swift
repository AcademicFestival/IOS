//
//  RegisterViewController1.swift
//  EntrepreneurshipApp
//
//  Created by 정성윤 on 2024/06/16.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

final class RegisterViewController1 : UIViewController{
    private let disposeBag = DisposeBag()
    private let registerViewModel = RegisterViewModel()
    private var seepassword : Bool = false
    private var seeRepassword : Bool = false
    //MARK: - UI Components
    //이메일
    private let idTitle : UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    //이메일 입력
    private let idView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let idText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.placeholder = "아이디를 입력해 주세요"
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return text
    }()
    //비밀번호
    private let passwordTitle : UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    //비밀번호 입력
    private let passwordView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let passwordText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.isSecureTextEntry = true //비밀번호 가리기
        text.placeholder = "비밀번호를 입력해주세요"
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return text
    }()
    //비밀번호 확인
    private lazy var seepasswordBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("🔐", for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(seepasswordBtnTapped), for: .touchUpInside)
        return btn
    }()
    //주소
    private let addressView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let addressTitle : UILabel = {
        let label = UILabel()
        label.text = "주소"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let addressText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.placeholder = "주소를 입력해 주세요"
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return text
    }()
    //다음 버튼
    private lazy var nextBtn : UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.setTitle("다음", for: .normal)
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
private extension RegisterViewController1 {
    private func setNavigation() {
        self.title = "회원가입"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
}

//MARK: - UI Layout
private extension RegisterViewController1 {
    private func setLayout() {
        self.view.addSubview(idTitle)
        self.idView.addSubview(idText)
        self.view.addSubview(idView)
        self.view.addSubview(passwordTitle)
        self.passwordView.addSubview(passwordText)
        self.passwordView.addSubview(seepasswordBtn)
        self.view.addSubview(passwordView)
        self.view.addSubview(addressTitle)
        self.addressView.addSubview(addressText)
        self.view.addSubview(addressView)
        self.view.addSubview(nextBtn)
        
        idTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(22)
            make.top.equalTo(144)
        }
        idView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(idTitle.snp.bottom).offset(10)
            make.height.equalTo(49)
        }
        idText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        passwordTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(idText.snp.bottom).offset(50)
            make.height.equalTo(22)
        }
        passwordView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(passwordTitle.snp.bottom).offset(10)
            make.height.equalTo(49)
        }
        passwordText.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(1.5)
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        seepasswordBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        addressTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(passwordText.snp.bottom).offset(50)
            make.height.equalTo(22)
        }
        addressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(addressTitle.snp.bottom).offset(10)
            make.height.equalTo(49)
        }
        addressText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        nextBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
}
//MARK: - Binding
private extension RegisterViewController1 {
    private func setBinding(){
        BindView()
    }
    private func BindView() {
        setKeyboard()
        setTextField()
    }
}
//MARK: - UI Action
extension RegisterViewController1 : UITextFieldDelegate {
    //Keyboard
    private func setKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    //TextField
    @objc private func setTextField() {
        idText.delegate = self
        passwordText.delegate = self
        addressText.delegate = self
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //버튼 활성화
        if (textField == idText) || (textField == passwordText) || (textField == addressText) {
            if (idText.text?.isEmpty == false) && (passwordText.text?.isEmpty == false) && (addressText.text?.isEmpty == false){
                nextBtn.isEnabled = true
                nextBtn.backgroundColor = .pointColor
            }else{
                nextBtn.isEnabled = false
                nextBtn.backgroundColor = .gray
            }
        }
    }
    //button
    @objc private func seepasswordBtnTapped() {
        if seepassword == false {
            self.passwordText.isSecureTextEntry = true
            self.seepassword = true
        }else{
            self.passwordText.isSecureTextEntry = false
            self.seepassword = false
        }
    }
    @objc private func seeRepasswordBtnTapped() {
        self.addressText.isSecureTextEntry = false
    }
    @objc private func nextBtnTapped() {
        self.navigationController?.pushViewController(RegisterViewController2(), animated: true)
    }
}
