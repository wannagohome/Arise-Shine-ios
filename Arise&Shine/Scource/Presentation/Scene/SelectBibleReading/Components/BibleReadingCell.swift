//
//  BibleReadingCell.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/18.
//

import UIKit

class BibleReadingCell: UITableViewCell {
    
    var schedule: BibleReadingSchedule? {
        didSet {
            self.textLabel?.text = self.schedule?.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
