//
//  UploadViewController.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Foundation
import UniformTypeIdentifiers
import NVActivityIndicatorView

final class UploadViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    private let disposeBag = DisposeBag()
    private let uploadViewModel = UploadViewModel()
    //MARK: - UI Components
    private let documentImage : UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "pdfImage")
        return view
    }()
    private let documentLabel : UILabel = {
        let label = UILabel()
        label.text = nil
        label.clipsToBounds = true
        label.textColor = .systemBlue
        label.backgroundColor = .white
        return label
    }()
    private lazy var uploadBtn : UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(uploadBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var signBtn : UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.setTitle("서명 이미지 업로드 📂", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(signBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var nextBtn : UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.clipsToBounds = true
        btn.backgroundColor = .gray
        btn.setTitle("다음", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return btn
    }()
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .ballDoubleBounce, color: .pointColor)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
        setNavigation()
        
        // 트리거를 구독하여 문서 선택기 present
        NotificationCenter.default.addObserver(self, selector: #selector(presentDocumentPicker), name: .init("presentDocumentPicker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentImagePicker), name: .init("presentImagePicker"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .init("presentDocumentPicker"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .init("presentImagePicker"), object: nil)
    }
}
//MARK: - UI Navigation
private extension UploadViewController {
    private func setNavigation() {
        self.title = ""
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
    }
}
//MARK: - UI Layout
private extension UploadViewController {
    private func setLayout() {
        self.view.addSubview(documentImage)
        self.view.addSubview(uploadBtn)
        self.view.addSubview(nextBtn)
        self.view.addSubview(signBtn)
        self.view.addSubview(documentLabel)
        self.view.addSubview(loadingIndicator)
        
        documentImage.snp.makeConstraints { make in
            make.center.equalToSuperview().inset(300)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        uploadBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().dividedBy(3)
            make.center.equalToSuperview()
        }
        nextBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 9)
            make.height.equalTo(50)
        }
        signBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(self.view.frame.height / 7)
        }
        documentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(nextBtn.snp.top).inset(-20)
            make.height.equalTo(20)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        loadingIndicator.startAnimating()
    }
}
//MARK: - Binding
private extension UploadViewController {
    private func setBinding() {
        uploadViewModel.serverToFileResult.subscribe(onNext: {[weak self] text in
            guard let self = self else {return}
            self.uploadViewModel.aiTrigger.onNext((text))
        }).disposed(by: disposeBag)
        uploadViewModel.aiResult.subscribe(onNext: {[weak self] question in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.nextBtn.isEnabled = true
                self.nextBtn.backgroundColor = .pointColor
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.type = .ballDoubleBounce
                self.loadingIndicator.startAnimating()
                self.nextBtn.rx.tap.subscribe{ _ in
                    if let question = question.first {
                        self.navigationController?.pushViewController(FormViewController(question: question), animated: true)
                    }
                }.disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
    private func BindView() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentDocumentPicker), name: .init("presentDocumentPicker"), object: nil)
    }
}
//MARK: - UI Action
extension UploadViewController {
    @objc private func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType(filenameExtension: "docx")!])
        documentPicker.delegate = uploadViewModel
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    @objc private func uploadBtnTapped() {
        print("uploadBtnTapped - called()")
        self.uploadViewModel.uploadTrigger.onNext(())
        self.uploadViewModel.uploadResult.subscribe(onNext: {[weak self] fileLabel in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.documentLabel.text = fileLabel
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.type = .ballRotateChase
                self.loadingIndicator.startAnimating()
            }
        }).disposed(by: disposeBag)
    }
    @objc private func signBtnTapped() {
        print("signBtnTapped - called()")
        self.uploadViewModel.imageTrigger.onNext(())
    }
    @objc func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                // 이미지를 서버로 전송
                print("\(imageData)")
                self.uploadViewModel.imageToServerTrigger.onNext(imageData)
                self.uploadViewModel.imageResult.onNext("Image uploaded successfully")
                self.showMessage(title: "이미지 업로드 완료", message: "")
            }
        } else {
            self.showMessage(title: "이미지 업로드 실패", message: "이미지를 가져올 수 없습니다.\n다시 시도해 보세요")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("Image picker was cancelled")
    }
    private func showMessage(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
