//
//  Bundle + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 31.03.2023.
//

import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
