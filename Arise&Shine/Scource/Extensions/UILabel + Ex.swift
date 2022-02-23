//
//  UILabel + Ex.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/02/20.
//

import UIKit

extension UILabel {
    var totalNumberOfLines: Int {
        let text = self.text! as NSString
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
