//
//  Color + Extension.swift
//  RightNow
//
//  Created by 정성윤 on 2024/06/18.
//

import Foundation
import UIKit

extension UIColor {
    static let pointColor : UIColor = {
        return UIColor(named: "pointColor") ?? .white
    }()
    static let whiteGray : UIColor = {
        return UIColor(named: "whiteGray") ?? .white
    }()
}
