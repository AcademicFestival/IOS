//
//  CreateDocumentViewModel.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/21.
//

import RxSwift
import RxCocoa
import Foundation

final class CreateDocumentViewModel {
    private let disposeBag = DisposeBag()
    
    //json
    let jsonTrigger = PublishSubject<[String:Any]>()
    let jsonResult = PublishSubject<URL>()
    
    init() {
        jsonTrigger.flatMapLatest { json in
            return JsonTodocx.json_to_docx(params: json)
        }
        .bind(to: jsonResult)
        .disposed(by: disposeBag)
    }
}
