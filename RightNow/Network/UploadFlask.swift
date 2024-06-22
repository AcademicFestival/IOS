//
//  UploadFlask.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/22.
//
import RxSwift
import RxCocoa
import Alamofire
import Foundation

final class UploadFlask {
    static func uploadFlask(fileData: Data) -> Observable<String> {
        return Observable.create { observer in
            let url = "http://172.20.10.9:8000/upload"
            AF.upload(multipartFormData: { formData in
                formData.append(fileData, withName: "file", fileName: "file.docx", mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
            }, to: url, method: .post, headers: ["Content-type": "multipart/form-data"])
            .validate()
            .responseDecodable(of: DocumentResponseModel.self) { response in
                switch response.result {
                case .success(let data):
                    if let string = data.extracted_text{
                        let decodedString = string.unicodeDecoded
                        observer.onNext(decodedString)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
