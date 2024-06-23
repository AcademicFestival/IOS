//
//  ImageFlask.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/23.
//

import RxSwift
import RxCocoa
import Alamofire
import Foundation

final class ImageFlask {
    static func uploadImage(fileData: Data) -> Observable<String> {
        return Observable.create { observer in
            let url = "http://172.20.10.9:8000/upload_img"
            print("업로드!")
            AF.upload(multipartFormData: { formData in
                formData.append(fileData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: ["Content-type": "multipart/form-data"])
            .validate()
            .response{ response in
                print(response.debugDescription)
                switch response.result {
                case .success(_):
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
