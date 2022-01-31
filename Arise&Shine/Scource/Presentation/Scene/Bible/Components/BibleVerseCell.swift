//
//  BibleVerseCell.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/14.
//

import UIKit

class BibleVerseCell: UITableViewCell {
    
    // MARK: - Properties
    
    var verse: BibleVerse? {
        didSet {
            self.verseLabel.text = self.verse?.sentence
            self.contentView.backgroundColor = self.verse?.isSelected ?? false ? .lightGray : .white
        }
    }

    // MARK: - Views
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var verseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
