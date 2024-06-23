//
//  RegisterViewController2.swift
//  EntrepreneurshipApp
//
//  Created by 정성윤 on 2024/06/16.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

final class RegisterViewController2 : UIViewController{
    private let disposeBag = DisposeBag()
    private let registerViewModel = RegisterViewModel()
    //MARK: - UI Components
    //생년월일
    private let birthTitle : UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let birthView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let birthText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.placeholder = "생년월일을 입력해 주세요(0000.00.00)"
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return text
    }()
    //이름
    private let nameTitle : UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    //이름 입력
    private let nameView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let nameText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.placeholder = "실명을 입력해주세요"
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return text
    }()
    //닉네임입력
    private let phoneTitle : UILabel = {
        let label = UILabel()
        label.text = "전화번호"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let phoneView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    private let phoneText : UITextField = {
        let text = UITextField()
        text.textColor = .black
        text.placeholder = "전화번호(000-0000-0000)"
        text.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return text
    }()
    //다음 버튼
    private lazy var nextBtn : UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.backgroundColor = .gray
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
private extension RegisterViewController2 {
    private func setNavigation() {
        self.title = "회원가입"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
}

//MARK: - UI Layout
private extension RegisterViewController2 {
    private func setLayout() {
        self.view.addSubview(birthTitle)
        self.birthView.addSubview(birthText)
        self.view.addSubview(birthView)
        self.view.addSubview(nameTitle)
        self.nameView.addSubview(nameText)
        self.view.addSubview(phoneTitle)
        self.view.addSubview(nameView)
        self.phoneView.addSubview(phoneText)
        self.view.addSubview(phoneView)
        self.view.addSubview(nextBtn)
        
        birthTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(22)
            make.top.equalTo(144)
        }
        birthView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(birthTitle.snp.bottom).offset(10)
            make.height.equalTo(49)
        }
        birthText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        nameTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(birthText.snp.bottom).offset(50)
            make.height.equalTo(22)
        }
        nameView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(nameTitle.snp.bottom).offset(10)
            make.height.equalTo(49)
        }
        nameText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        phoneTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(nameView.snp.bottom).offset(50)
            make.height.equalTo(22)
        }
        phoneView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(phoneTitle.snp.bottom).offset(10)
            make.height.equalTo(49)
        }
        phoneText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        nextBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 7)
            make.height.equalTo(50)
        }
    }
}
//MARK: - Binding
private extension RegisterViewController2 {
    private func setBinding(){
        BindView()
    }
    private func BindView() {
        setKeyboard()
        setTextField()
    }
}
//MARK: - UI Action
extension RegisterViewController2 : UITextFieldDelegate {
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
        nameText.delegate = self
        phoneText.delegate = self
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //버튼 활성화
        if (textField == nameText) || (textField == phoneText) {
            if  (nameText.text?.isEmpty == false) && (phoneText.text?.isEmpty == false){
                nextBtn.isEnabled = true
                nextBtn.backgroundColor = .pointColor
            }else{
                nextBtn.isEnabled = false
                nextBtn.backgroundColor = .gray
            }
        }
    }
    @objc private func nextBtnTapped() {
        let birthDay : String = birthText.text ?? ""
        let phoneNumber : String = phoneText.text ?? ""
        if birthDay.count > 7 && phoneNumber.count > 8 {
            let birthDayIndex4 = birthDay.index(birthDay.startIndex, offsetBy: 4)
            let birthDayIndex7 = birthDay.index(birthDay.startIndex, offsetBy: 7)
            let phoneNumberIndex3 = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let phoneNumberIndex8 = phoneNumber.index(phoneNumber.startIndex, offsetBy: 8)
            
            if birthDay[birthDayIndex4] == "." && birthDay[birthDayIndex7] == "." && phoneNumber[phoneNumberIndex3] == "-" && phoneNumber[phoneNumberIndex8] == "-" {
                self.navigationController?.pushViewController(RegisterViewController3(), animated: true)
            }else{
                self.showAlert(title: "양식 확인", message: "생년월일 혹은 전화번호 양식이 잘못되었습니다. 다시 확인해 주세요.")
            }
        }else{
            self.showAlert(title: "양식 확인", message: "생년월일 혹은 전화번호 양식이 잘못되었습니다. 다시 확인해 주세요.")
        }
    }
    private func showAlert(title : String, message : String) {
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "확인", style: .default)
        Alert.addAction(Ok)
        self.present(Alert, animated: true)
    }
}
