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
    public func postAiNetwork(params : String) -> Observable<AiResponseModel>{
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "The file text I gave you is an extract of the table contents of a certain document format. Here, select the items we need to enter or select and write them in json format. Please speak politely in Korean."],
                ["role": "user", "content": "FileText : \(params)"]
            ]
        ]
        return network.AiNetwork(params: parameters)
    }
}
