//
//  LoginViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Foundation

final class LoginViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let loginViewModel = LoginViewModel()
    
    //MARK: - UI Components
    private var seepassword : Bool = false
    private let loginImage : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "loginImage")
        return view
    }()
    //아이디
    private let idTitle : UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    //아이디 입력
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
        text.isSecureTextEntry = true //비밀번호 가리기(암호화)
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
    //로그인 버튼
    private lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.backgroundColor = .gray
        btn.setTitle("로그인", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        btn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var registerBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("회원가입", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.addTarget(self, action: #selector(registerBtnTapped), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setNavigation()
    }
}
//MARK: - UI Navigation
private extension LoginViewController {
    private func setNavigation() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.title = ""
    }
}
//MARK: - UI Layout
private extension LoginViewController {
    private func setLayout() {
        self.view.addSubview(loginImage)
        self.view.addSubview(idTitle)
        self.idView.addSubview(idText)
        self.view.addSubview(idView)
        self.view.addSubview(passwordTitle)
        self.passwordView.addSubview(passwordText)
        self.passwordView.addSubview(seepasswordBtn)
        self.view.addSubview(passwordView)
        self.view.addSubview(loginBtn)
        self.view.addSubview(registerBtn)
        loginImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
        idTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.center.equalToSuperview().offset(30)
            make.height.equalTo(22)
        }
        idView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(idTitle.snp.bottom).offset(10)
            make.height.equalTo(49)
        }
        idText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        passwordTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(idText.snp.bottom).offset(30)
            make.height.equalTo(22)
        }
        passwordView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
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
        loginBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 7)
            make.height.equalTo(50)
        }
        registerBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(idTitle.snp.bottom)
        }
    }
}
//MARK: - Binding
extension LoginViewController : UITextFieldDelegate{
    private func setBinding() {
        BindView()
    }
    private func BindView() {
        setKeyboard()
        idText.delegate = self
        passwordText.delegate = self
    }
    private func setKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //버튼 활성화
        if (textField == idText) || (textField == passwordText){
            if (idText.text?.isEmpty == false) && (passwordText.text?.isEmpty == false) {
                loginBtn.isEnabled = true
                loginBtn.backgroundColor = .pointColor
            }else{
                loginBtn.isEnabled = false
                loginBtn.backgroundColor = .gray
            }
        }
    }
}
//MARK: - UI Action
private extension LoginViewController {
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
    @objc private func loginBtnTapped() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    @objc private func registerBtnTapped() {
        self.navigationController?.pushViewController(RegisterViewController1(), animated: true)
    }
}
