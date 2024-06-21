//
//  GetFormResponseModel.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/21.
//

import Foundation
// MARK: - Welcome
struct GetFormResponseModel: Codable {
    let items: [GetItem]
    let totalItems, pageCount: Int

    enum CodingKeys: String, CodingKey {
        case items
        case totalItems = "total_items"
        case pageCount = "page_count"
    }
}

// MARK: - Item
struct GetItem: Codable {
    let landingID, token, responseID, responseType: String
    let landedAt, submittedAt: String
    let metadata: GetMetadata
    let hidden: GetHidden
    let calculated: GetCalculated
    let answers: [GetAnswer]

    enum CodingKeys: String, CodingKey {
        case landingID = "landing_id"
        case token
        case responseID = "response_id"
        case responseType = "response_type"
        case landedAt = "landed_at"
        case submittedAt = "submitted_at"
        case metadata, hidden, calculated, answers
    }
}

// MARK: - Answer
struct GetAnswer: Codable {
    let field: GetField
    let type, text: String
}

// MARK: - Field
struct GetField: Codable {
    let id, type, ref: String
}

// MARK: - Calculated
struct GetCalculated: Codable {
    let score: Int
}

// MARK: - Hidden
struct GetHidden: Codable {
}

// MARK: - Metadata
struct GetMetadata: Codable {
    let userAgent, platform: String
    let referer: String
    let networkID, browser: String

    enum CodingKeys: String, CodingKey {
        case userAgent = "user_agent"
        case platform, referer
        case networkID = "network_id"
        case browser
    }
}
