//
//  flaskTest.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/17.
//

import Foundation
import Alamofire

class flaskTest {
    static func generateApplicationForm(copyrightInfo: [String: Any], today: [String: Any], completion: @escaping (Result<URL, Error>) -> Void) {
        let url = "http://172.16.116.174:8000/generate_application_form"
        
        let parameters: [String: Any] = [
            "copyright_INFO": copyrightInfo,
            "today": today
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    guard let httpResponse = response.response,
                          let contentDisposition = httpResponse.headers["Content-Disposition"],
                          let filename = contentDisposition.components(separatedBy: "filename=").last else {
                        completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: (response.response?.statusCode ?? -1)))))
                        return
                    }
                    print("Received file name: \(filename)")
                    
                    // 파일을 저장할 경로 설정
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileURL = documentsURL.appendingPathComponent(filename)
                    
                    // 파일 저장
                    do {
                        try data.write(to: fileURL)
                        print("File saved at: \(fileURL.path)")
                        
                        completion(.success(fileURL))
                    } catch {
                        print("Failed to save file: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Download failed with error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
