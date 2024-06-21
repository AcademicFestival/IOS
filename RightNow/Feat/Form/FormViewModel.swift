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
    let createFormTrigger = PublishSubject<Void>()
    let getFormTrigger = PublishSubject<String>()
    
    // Outputs
    let createFormResult = PublishSubject<[String]>()
    let getFormResult = PublishSubject<[String: Any]>()
    
    init() {
        createFormTrigger
            .flatMapLatest { [weak self] _ -> Observable<[String]> in
                guard let self = self else { return Observable.empty() }
                return self.createForm()
            }
            .bind(to: createFormResult)
            .disposed(by: disposeBag)
        
        getFormTrigger
            .flatMapLatest { [weak self] formId -> Observable<[String: Any]> in
                guard let self = self else { return Observable.empty() }
                return self.getForm(formId: formId)
            }
            .bind(to: getFormResult)
            .disposed(by: disposeBag)
    }
    
    private func createForm() -> Observable<[String]> {
        return Observable.create { observer in
            let fullPath = "https://api.typeform.com/forms"
            let form : [String:Any] = [
                "title": "설문",
                "fields": [
                    [
                        "type": "long_text",
                        "title": "※ 충분한 설명이 되도록 자세히 기재 (10자 이상 1,000자 이하, 기재란 부족시 별지 기재 첨부 )"
                    ]
                ]
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
    
    private func getForm(formId: String) -> Observable<[String: Any]> {
        return Observable.create { observer in
            let fullPath = "https://api.typeform.com/forms/\(formId)"
            AF.request(fullPath, method: .get, headers: ["Content-Type":"application/json", "Authorization":"Bearer \(self.apiKey)"])
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
