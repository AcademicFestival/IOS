//
//  NetworkProvider.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/18.
//

import RxCocoa
import RxSwift
import Foundation

final class NetworkProvider {
    private let endpoint : String
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    //MARK: - OpenAI
    public func aiNetwork() -> AiNetwork {
        let network = Network<AiResponseModel>(endpoint)
        return AiNetwork(network: network)
    }
    //MARK: - Upload File
    
}
