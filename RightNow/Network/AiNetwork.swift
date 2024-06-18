//
//  AiNetwork.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/18.
//

import RxSwift
import RxCocoa
import Foundation

final class AiNetwork {
    private let network : Network<AiResponseModel>
    init(network: Network<AiResponseModel>) {
        self.network = network
    }
    public func postAiNetwork() -> Observable<AiResponseModel>{
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "The file text I gave you is an extract of the table contents of a certain document format. Here, select the items we need to enter or select and write them in json format. Please speak politely in Korean."],
                ["role": "user", "content": "FileText : 저작권 등록신청명세서  ※□에는 V표를 합니다 저  작  물    ① 제 호   (제 목)        ※ 외국어는 한글 병기 ② 종 류  ※ 반드시 뒤쪽의 분류표를 참고할 것 ③ 복제물   형 태        □ 책     □ 인쇄물 □ 사진  □ CD  □ DVD    □ 디스켓 □ Tape  □ 비디오테이프  □ 기타(   )                                    ④ 복제물   수 량 경우 기재하지 않음 ※ 기존 등록물인 ⑤    내    용    ※ 충분한 설명이 되도록 자세히 기재 (10자 이상 1,000자 이하, 기재란 부족시 별지 기재 첨부 ) ⑥ 전등록번호 및 등록연월일                    ※ 동일 저작물에 기존 등록 있는 경우에만 기재 등  록  사  항    2차적저작물   ※ 원작을 번역ㆍ편곡ㆍ변형ㆍ각색ㆍ영상제작 등의 방법으로 재창작한 저작물을 등록 신청하는 경우에만 기재                ⑦ 원저작물의 제호 ⑧ 원저작물의 저작자 ⑨ 권리에 대한 지분                ※ 공동저작자인 경우에만 기재 창 작            ⑩ 창작연월일 공 표            ⑪ 공표연월일                    ⑫ 공표국가 ⑬ 공표방법    □ 출판   □ 복제 ㆍ 배포 □ 인터넷 □ 공연 □ 전시 □ 방송   □ 기타(   )                ⑭ 공표매체정보 ⑮ 공표 시 표시한 저작자 성명(이명) 저작자            ꊉꊘ 성   명  (사업자명)    한글)                            한자)  영문) 저작자 ※ 신청인과 같은 경우 아래에 v표를 하고 기재하지 않음  □ 신청인과 같음            ꊉꊙ 국  적            ꊉꊚ 주민등록번호    (법인등록번호) ꊉꊛ 주  소 ꊊꊒ 전화번호    자택(사무소)    휴대전화                ꊊꊓ 전자 우편주소 ꊊꊔ 사망연도    ※ 저작자 사망시에만 기재 "]
            ]
        ]
        return network.AiNetwork(params: parameters)
    }
}
