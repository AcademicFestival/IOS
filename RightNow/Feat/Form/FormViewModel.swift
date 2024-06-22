//
//  FormViewModel.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/21.
//

import RxCocoa
import RxSwift
import Alamofire
import Foundation

final class FormViewModel {
    private let disposeBag = DisposeBag()
    private let apiKey = ""
    // Inputs
    let createFormTrigger = PublishSubject<String>()
    let getFormTrigger = PublishSubject<String>()
    
    // Outputs
    let createFormResult = PublishSubject<[String]>()
    let getFormResult = PublishSubject<[String]>()
    
    //Question
    static var questionArray : [String] = []
    
    init() {
        createFormTrigger
            .flatMapLatest { [weak self] question -> Observable<[String]> in
                guard let self = self else { return Observable.empty() }
                return self.createForm(question)
            }
            .bind(to: createFormResult)
            .disposed(by: disposeBag)
        
        getFormTrigger
            .flatMapLatest { [weak self] formId -> Observable<[String]> in
                guard let self = self else { return Observable.empty() }
                return self.getForm(formId: formId)
            }
            .bind(to: getFormResult)
            .disposed(by: disposeBag)
    }
    
    private func createForm(_ question : String) -> Observable<[String]> {
        return Observable.create { observer in
            let fullPath = "https://api.typeform.com/forms"
            let questions = self.extractQuotedStrings(from: question)
            var field: [[String: Any]] = Array(repeating: [:], count: questions.count)

            for (index, question) in questions.enumerated() {
                field[index] = ["type": "long_text", "title": question]
            }
//            print(field)
            let form : [String:Any] = [
                "title": "문서생성",
                "fields": field
            ]
            AF.request(fullPath, method: .post, parameters: form, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Authorization":"Bearer \(self.apiKey)"])
                .validate()
                .responseDecodable(of: FormResponseModel.self){ response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext([data.id, data.links.display])
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    private func getForm(formId: String) -> Observable<[String]> {
        return Observable.create { observer in
            let fullPath = "https://api.typeform.com/forms/\(formId)/responses"
            AF.request(fullPath, method: .get, headers: ["Content-Type":"application/json", "Authorization":"Bearer \(self.apiKey)"])
                .validate()
                .responseDecodable(of: GetFormResponseModel.self){ response in
                    switch response.result {
                    case .success(let data):
                        let answer = data.items.compactMap({ $0.answers })
                        if let text = answer.first?.compactMap({ $0.text }){
                            observer.onNext(text)
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    private func extractsubStrings(from text: String) -> [String] {
        // 정규식 패턴
        let pattern = "\"([^\"]*)\""
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            
            return results.map { nsString.substring(with: $0.range(at: 1)) }.filter { !$0.isEmpty }
        } catch {
            print("정규식을 생성하는 도중 에러가 발생했습니다: \(error)")
            return []
        }
    }
    private func extractQuotedStrings(from text: String) -> [String] {
        // JSON 문자열을 Data로 변환
        var keys : [String] = []
        var question : [String] = []
        if let jsonData = text.data(using: .utf8) {
            do {
                // JSON 데이터를 딕셔너리로 변환
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // 키 값 추출
                        for key in jsonDict.keys {
                            question.append(key)
                        if let nestedDict = jsonDict[key] as? [String: Any]{
                            let subKey = extractsubStrings(from: "\(nestedDict)")
                            keys.append("\(key). ex:\(subKey)")
                        }else{
                            if let nestedDict = jsonDict[key] as? [String]{
                                let subKey = extractsubStrings(from: "\(nestedDict)")
                                keys.append("\(key). ex:\(subKey)")
                            }else{
                                keys.append(key)
                            }
                        }
                    }
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        FormViewModel.questionArray = question
        return keys
    }
}
