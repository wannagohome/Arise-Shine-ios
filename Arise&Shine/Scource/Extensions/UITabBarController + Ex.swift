//
//  UITabBarController + Ex.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/24.
//

import UIKit

import RxSwift
import RxCocoa

extension UITabBarController {
    func setTabBarHidden(_ isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil ) {
        
        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (isHidden ? 0 : height)
        let duration = (animated ? 0.25 : 0.0)

        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame = frame
        }) { _ in
            completion?()
        }
    }
}
