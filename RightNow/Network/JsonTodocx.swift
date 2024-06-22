//
//  JsonTodocx.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/17.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class JsonTodocx {
    static func json_to_docx(params : [String:Any]) -> Observable<URL> {
        return Observable.create { observer in
            let url = "http://172.20.10.9:8000/json_to_docx"
            
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let httpResponse = response.response,
                              let contentDisposition = httpResponse.headers["Content-Disposition"],
                              let filename = contentDisposition.components(separatedBy: "filename=").last else {return}
                        
                        // 파일을 저장할 경로 설정
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsURL.appendingPathComponent(filename)
                        
                        // 파일 저장
                        do {
                            try data.write(to: fileURL)
                            print("File saved at: \(fileURL.path)")
                            
                            observer.onNext(fileURL)
                        } catch { observer.onError(error) }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
