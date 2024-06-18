//
//  AiResponseModel.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/18.
//

import Foundation

struct AiResponseModel : Codable {
    let choices : [Choice]
}
struct Choice : Codable {
    let message: Message
}
struct Message: Codable {
    let content: String
}
