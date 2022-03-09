//
//  CircleView.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import UIKit

final class CircleView: UIView {
    private let color: UIColor
    
    init(color: UIColor) {
        self.color = color
        super.init(frame: .zero)
        defer {
            self.clipsToBounds = true
            self.backgroundColor = .clear
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        self.color.setFill()
        path.fill()
    }
}
