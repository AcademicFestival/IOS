//
//  MainViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import UIKit

final class MainViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let mainViewModel = MainViewModel()
    //MARK: - UI Components
    private let titleText : UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        view.textAlignment = .left
        view.isEditable = false
        let attributedText = NSMutableAttributedString()
        
        let largeFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        let largeTextAttributes: [NSAttributedString.Key: Any] = [
            .font: largeFont,
            .foregroundColor: UIColor.black
        ]
        let largeText = NSAttributedString(string: "정성윤님, 문서 등록하고\n\n", attributes: largeTextAttributes)
        attributedText.append(largeText)
        
        let mediumFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let mediumTextAttributes: [NSAttributedString.Key: Any] = [
            .font: mediumFont,
            .foregroundColor: UIColor.black
        ]
        let mediumText = NSAttributedString(string: "간편하게 새로운 문서를 생성해 보세요.", attributes: mediumTextAttributes)
        attributedText.append(mediumText)
        
        view.attributedText = attributedText
        return view
    }()
    //버튼
    private lazy var createBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("맞춤 문서 생성하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .pointColor
        btn.addTarget(self, action: #selector(createBtnTapped), for: .touchUpInside)
        return btn
    }()
    private let spacing : UIView = {
        let view = UIView()
        view.backgroundColor = .whiteGray
        return view
    }()
    private let tableLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "⏬  최신순"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let tableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        view.isPagingEnabled = false
        view.register(MainTableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigation()
        setBinding()
    }
}
//MARK: - UI Navigation
private extension MainViewController {
    private func setNavigation() {
        self.title = ""
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = .black
        self.view.clipsToBounds = true
        self.view.backgroundColor = .white
    }
}
//MARK: - UI Layout
private extension MainViewController {
    private func setLayout() {
        self.view.addSubview(titleText)
        self.view.addSubview(createBtn)
        self.view.addSubview(spacing)
        self.view.addSubview(tableLabel)
        self.view.addSubview(tableView)
        titleText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(self.view.frame.height / 8)
        }
        createBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.top.equalTo(titleText.snp.bottom).offset(30)
        }
        spacing.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(createBtn.snp.bottom).offset(30)
        }
        tableLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(20)
            make.top.equalTo(spacing.snp.bottom).offset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
        }
    }
}
//MARK: - UI Binding
private extension MainViewController {
    private func setBinding() {
        mainViewModel.inputTrigger.onNext(())
        mainViewModel.mainTable
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: MainTableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(MainTableResponseModel.self)
            .subscribe { selectedModel in
//                self.navigationController?.pushViewController(MainDetailViewController(coinData: selectedModel), animated: true)
            }
            .disposed(by: disposeBag)
    }
    @objc private func createBtnTapped() {
        self.navigationController?.pushViewController(UploadViewController(), animated: true)
    }
}
