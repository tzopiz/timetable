//
//  Resources + ext Image.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 13.08.2023.
//

import UIKit

extension App {
    enum Images {
        static func icon(for tab: Tabs) -> UIImage? {
            switch tab {
            case .overview: return UIImage(systemName: "house")
            case .tasks:    return UIImage(systemName: "list.bullet.rectangle")
            case .people:   return UIImage(systemName: "person")
            case .profile:  return UIImage(systemName: "gear")
            }
        }
        
        static let backgroundSPBU = #imageLiteral(resourceName: "spbu")
        
        static let lessonsCanceledLight = [#imageLiteral(resourceName: "Gamers using different devices and playing on mobile phone.png"), #imageLiteral(resourceName: "8401.png"), #imageLiteral(resourceName: "8728.png"), #imageLiteral(resourceName: "10966.png"), #imageLiteral(resourceName: "11057.png"), #imageLiteral(resourceName: "Happy girl wearing headphones.png")]
        static let lessonsCanceledDark = [#imageLiteral(resourceName: "8270.png"), #imageLiteral(resourceName: "Female designer working late in room flat vector illustration.png")]
        static let nullBackground = #imageLiteral(resourceName: "null_background")
        static let icon = #imageLiteral(resourceName: "icon")
        
        static let clock = #imageLiteral(resourceName: "clock@256")
        
        static let downArrow = #imageLiteral(resourceName: "chevron_down@256x")
        static let addButton = #imageLiteral(resourceName: "plus.circle.fill@256x.png")
        
        static let checkmarkDone    = #imageLiteral(resourceName: "checkmark_circle@256x")
        static let checkmarkNotDone = #imageLiteral(resourceName: "circle@256x.png")
        static let notification = #imageLiteral(resourceName: "notification_point")
        
        static let theme        = #imageLiteral(resourceName: "theme")
        static let imageProfile = #imageLiteral(resourceName: "person_crop_circle_fill@128x")
        static let changeGroup  = #imageLiteral(resourceName: "person_2_gobackward@256x")
        static let share        = #imageLiteral(resourceName: "square_and_arrow_up@256x")
        static let aboutApp     = #imageLiteral(resourceName: "info_circle@256x")
        static let exit         = #imageLiteral(resourceName: "rectangle_portrait_and_arrow_forward@256x")
        
        static let warning = #imageLiteral(resourceName: "warning@128")
        static let exclamation_1 = #imageLiteral(resourceName: "warning_1@64")
        static let exclamation_2 = #imageLiteral(resourceName: "warning_2@64")
        static let exclamation_3 = #imageLiteral(resourceName: "warning_3@64")
        
        static let vk_icon = #imageLiteral(resourceName: "vk_icon")
        static let tg_icon = #imageLiteral(resourceName: "tg_icon")
        static let github_icon = #imageLiteral(resourceName: "github_icon")
    }
}

