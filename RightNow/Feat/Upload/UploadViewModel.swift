//
//  UploadViewModel.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/18.
//

import PDFKit
import RxSwift
import RxCocoa
import Foundation
import UniformTypeIdentifiers

final class UploadViewModel: NSObject, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let disposeBag = DisposeBag()
    private var aiNetwork : AiNetwork
    
    //Ai
    let aiTrigger = PublishSubject<String>()
    let aiResult : PublishSubject<[String]> = PublishSubject()
    
    //파일 업로드
    let uploadTrigger = PublishSubject<Void>()
    let uploadResult : PublishSubject<String> = PublishSubject()
    
    //서버로 파일 전송
    let serverToFileTrigger = PublishSubject<Data>()
    let serverToFileResult : PublishSubject<String> = PublishSubject()
    
    private var selectedFileURL : URL? //선택된 파일 URL
    private var imageFileURL : URL? //이미지 URL
    
    //이미지
    let imageTrigger = PublishSubject<Void>()
    let imageResult: PublishSubject<String> = PublishSubject()
    let imageToServerTrigger = PublishSubject<Data>()
    let imageToServerResult: PublishSubject<String> = PublishSubject()
    
    
    override init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        aiNetwork = provider.aiNetwork()
        super.init()
        
        //Ai
        aiTrigger.subscribe(onNext: { [weak self] question in
            guard let self = self else {return}
            self.aiNetwork.postAiNetwork(params: question).subscribe(onNext: {[weak self] result in
                guard let self = self else {return}
                let message = result.choices.compactMap({ $0.message })
                let content = message.compactMap { $0.content }
                self.aiResult.onNext(content)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        //Document Upload
        uploadTrigger.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.uploadButtonTapped()
        }).disposed(by: disposeBag)
        
        //Upload To Server(Document)
        serverToFileTrigger.flatMapLatest { fileData in
            return UploadFlask.uploadFlask(fileData: fileData)
        }
        .bind(to: serverToFileResult)
        .disposed(by: self.disposeBag)
        
        // Image Upload
        imageTrigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.uploadImageTapped()
        }).disposed(by: disposeBag)
        
        imageToServerTrigger.subscribe(onNext: { [weak self] fileData in
            guard let self = self else { return }
            ImageFlask.uploadImage(fileData: fileData).subscribe{ result in
                self.imageToServerResult.onNext(result)
            }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}
extension UploadViewModel {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedFileURL = urls.first {
            self.selectedFileURL = selectedFileURL
            
            //파일 접근 권한 요청
            let isAccessing = selectedFileURL.startAccessingSecurityScopedResource()
            defer { if isAccessing { selectedFileURL.stopAccessingSecurityScopedResource() }}
            
            //파일명 디코딩
            let fileName = selectedFileURL.deletingPathExtension().lastPathComponent
            if let encodedString = fileName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedString),
               let decodedString = url.lastPathComponent.removingPercentEncoding {
                print("Decoded file name: \(decodedString)")
                
                // 파일 데이터 가져오기
                do {
                    let fileData = try Data(contentsOf: selectedFileURL)
                    // 파일 데이터 활용
                    // fileData => UI upadte
                    self.uploadResult.onNext(decodedString)
                    self.serverToFileTrigger.onNext(fileData)
                    print("File data loaded successfully.")
                } catch {
                    self.showMessage(title: "데이터 업로드 실패", message: "데이터를 가져올 수 없습니다.\n다시 시도해 보세요")
                }
            }
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    private func showMessage(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        let uploadVC = UploadViewController()
        uploadVC.present(alert, animated: true)
    }
    func uploadButtonTapped() {
        NotificationCenter.default.post(name: .init("presentDocumentPicker"), object: nil)
    }
}
// MARK: - Image Upload
extension UploadViewModel {
    func uploadImageTapped() {
        NotificationCenter.default.post(name: .init("presentImagePicker"), object: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                // 이미지를 서버로 전송
                print("\(imageData)")
                self.imageToServerTrigger.onNext(imageData)
                self.imageResult.onNext("Image uploaded successfully")
            }
        } else {
            self.showMessage(title: "이미지 업로드 실패", message: "이미지를 가져올 수 없습니다.\n다시 시도해 보세요")
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("Image picker was cancelled")
    }
}
