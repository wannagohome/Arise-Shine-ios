//
//  PrayerCell.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/02/06.
//

import UIKit

class PrayerCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: PrayerDelegate?
    private var prayer: Prayer?
    private let dateFormatter = DateFormatter()
    private let minute: Double = 60
    private let hour: Double = 60*60
    private let day: Double = 60*60*24

    // MARK: - Views
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label?.lineBreakMode = .byTruncatingTail
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func configure(by prayer: Prayer) {
        self.prayer = prayer
        self.label.text = prayer.contents
        self.label.numberOfLines = prayer.isOpened ? 0 : 3
        self.dateLabel.text = prayer.createdAt
        self.openButton.isHidden = !(self.label.totalNumberOfLines > 3 && !(prayer.isOpened))
    }
    
    @IBAction func tapOpen(_ sender: Any) {
        if let prayer = self.prayer {
            self.delegate?.open(prayer)
        }
    }
    
    @IBAction func tapOption(_ sender: Any) {
        let view = UIView(frame: CGRect(x: self.optionButton.frame.maxX - 110, y: self.optionButton.frame.minY + 5, width: 100, height: 50))
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        self.contentView.addSubview(view)
    }
}

protocol PrayerDelegate: class {
    func open(_ prayer: Prayer)
}
