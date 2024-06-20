//
//  FormResponseModel.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/20.
//

import Foundation
import Foundation

struct FormResponseModel: Codable {
    let id, type, title: String
    let workspace, theme: Theme
    let settings: Settings
    let thankyouScreens: [ThankyouScreen]
    let fields: [Field]
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id, type, title, workspace, theme, settings
        case thankyouScreens = "thankyou_screens"
        case fields
        case links = "_links"
    }
}

// MARK: - Field
struct Field: Codable {
    let id, title, ref: String
    let validations: Validations
    let type: String
}

// MARK: - Validations
struct Validations: Codable {
    let validationsRequired: Bool
    
    enum CodingKeys: String, CodingKey {
        case validationsRequired = "required"
    }
}

// MARK: - Links
struct Links: Codable {
    let display, responses: String
}

// MARK: - Settings
struct Settings: Codable {
    let language, progressBar: String
    let meta: Meta
    let hideNavigation, isPublic, isTrial, showProgressBar: Bool
    let showTypeformBranding, areUploadsPublic, showTimeToComplete, showNumberOfSubmissions: Bool
    let showCookieConsent, showQuestionNumber, showKeyHintOnChoices, autosaveProgress: Bool
    let freeFormNavigation, useLeadQualification, proSubdomainEnabled: Bool
    let capabilities: Capabilities
    
    enum CodingKeys: String, CodingKey {
        case language
        case progressBar = "progress_bar"
        case meta
        case hideNavigation = "hide_navigation"
        case isPublic = "is_public"
        case isTrial = "is_trial"
        case showProgressBar = "show_progress_bar"
        case showTypeformBranding = "show_typeform_branding"
        case areUploadsPublic = "are_uploads_public"
        case showTimeToComplete = "show_time_to_complete"
        case showNumberOfSubmissions = "show_number_of_submissions"
        case showCookieConsent = "show_cookie_consent"
        case showQuestionNumber = "show_question_number"
        case showKeyHintOnChoices = "show_key_hint_on_choices"
        case autosaveProgress = "autosave_progress"
        case freeFormNavigation = "free_form_navigation"
        case useLeadQualification = "use_lead_qualification"
        case proSubdomainEnabled = "pro_subdomain_enabled"
        case capabilities
    }
}

// MARK: - Capabilities
struct Capabilities: Codable {
    let e2EEncryption: E2EEncryption
    
    enum CodingKeys: String, CodingKey {
        case e2EEncryption = "e2e_encryption"
    }
}

// MARK: - E2EEncryption
struct E2EEncryption: Codable {
    let enabled, modifiable: Bool
}

// MARK: - Meta
struct Meta: Codable {
    let allowIndexing: Bool
    
    enum CodingKeys: String, CodingKey {
        case allowIndexing = "allow_indexing"
    }
}

// MARK: - ThankyouScreen
struct ThankyouScreen: Codable {
    let id, ref, title, type: String
    let properties: Properties
    let attachment: Attachment
}

// MARK: - Attachment
struct Attachment: Codable {
    let type: String
    let href: String
}

// MARK: - Properties
struct Properties: Codable {
    let showButton, shareIcons: Bool
    let buttonMode, buttonText: String
    
    enum CodingKeys: String, CodingKey {
        case showButton = "show_button"
        case shareIcons = "share_icons"
        case buttonMode = "button_mode"
        case buttonText = "button_text"
    }
}

// MARK: - Theme
struct Theme: Codable {
    let href: String
}
