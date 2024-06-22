//
//  String + Extension.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/22.
//

import Foundation
extension String {
    var unicodeDecoded: String {
        let temp = self.replacingOccurrences(of: "\\u", with: "\\U")
        let temp1 = temp.replacingOccurrences(of: "\"", with: "\\\"")
        let temp2 = "\"\(temp1)\""
        let data = temp2.data(using: .utf8)!
        let decoded = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? String
        return decoded ?? self
    }
}
