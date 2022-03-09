//
//  PlanCell.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/18.
//

import UIKit

class PlanCell: UITableViewCell {
    
    var schedule: Schedule? {
        didSet {
            self.textLabel?.text = self.schedule?.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
