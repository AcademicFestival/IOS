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
//        btn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
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
    }
}
//MARK: - UI Layout
private extension LoginViewController {
    private func setLayout() {
        self.view.addSubview(idTitle)
        self.idView.addSubview(idText)
        self.view.addSubview(idView)
        self.view.addSubview(passwordTitle)
        self.passwordView.addSubview(passwordText)
        self.passwordView.addSubview(seepasswordBtn)
        self.view.addSubview(passwordView)
        self.view.addSubview(loginBtn)
        
        idTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.center.equalToSuperview()
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
            make.top.equalTo(idText.snp.bottom).offset(50)
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
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
}
//MARK: - Binding
private extension LoginViewController {
    private func setBinding() {
        BindView()
    }
    private func BindView() {
        
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
}
