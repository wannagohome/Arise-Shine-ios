//
//  CALayer + Ex.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import UIKit

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case .top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
            case .bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
            case .left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
            case .right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
            case .all:
                self.addBorder([.top, .bottom, .left, .right], color: color, width: width)
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
