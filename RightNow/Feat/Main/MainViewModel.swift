//
//  MainViewModel.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/22.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    private let disposeBag = DisposeBag()
    let inputTrigger = PublishSubject<Void>()
    let mainTable = BehaviorSubject<[MainTableResponseModel]>(value: [])
    init() {
        inputTrigger
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let mockData = [
                    MainTableResponseModel(title: "휴학원서.pdf", date: "2024.06.23", type: "pdf"),
                    MainTableResponseModel(title: "휴학원서.docx", date: "2024.06.23", type: "docx"),
                    MainTableResponseModel(title: "저작권등록명세서.pdf", date: "2024.06.23", type: "pdf"),
                    MainTableResponseModel(title: "저작권신청명세서.pdf", date: "2024.06.22", type: "pdf"),
                    MainTableResponseModel(title: "개인정보활용동의서.pdf", date: "2024.06.22", type: "pdf"),
                    MainTableResponseModel(title: "편입신청서.docx", date: "2024.06.22", type: "docx"),
                    MainTableResponseModel(title: "편입신청서.pdf", date: "2024.06.22", type: "pdf"),
                    MainTableResponseModel(title: "영어인증자격신청서.pdf", date: "2024.06.22", type: "pdf")
                ]
                self.mainTable.onNext(mockData)
            })
            .disposed(by: disposeBag)
    }
}
