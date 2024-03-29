//
//  UIViewController + Ex.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import UIKit

extension UIViewController {
    private class func fromStoryboard<T>(storyboard: String, className: String, as type: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: className)
        
        guard let rusult = viewController as? T else {
            fatalError("View Controller Couldn't find.")
        }
        
        return rusult
    }
    
    class func withStoryboard(storyboard: StoryboardType) -> Self {
        fromStoryboard(storyboard: storyboard.fileName, className: className, as: self)
    }
}


enum StoryboardType {
    case bible
    case bibleFont
    case select
    
    case plan
    
    case prayer
    case newVIP
    case vipDetail
    case newPrayer
    
    case setting
    case selectPlan
    
    var fileName: String {
        switch self {
        case .bible:
            return "BibleViewController"
        case .bibleFont:
            return "BibleFontViewController"
        case .select:
            return "SelectViewController"
            
        case .plan:
            return "PlanViewController"
            
        case .prayer:
            return "PrayerViewController"
        case .newVIP:
            return "NewVIPViewController"
        case .vipDetail:
            return "VIPDetailViewController"
        case .newPrayer:
            return "NewPrayerViewController"
            
        case .setting:
            return "SettingViewController"
        case .selectPlan:
            return "SelectPlanViewController"
        }
    }
    
}

