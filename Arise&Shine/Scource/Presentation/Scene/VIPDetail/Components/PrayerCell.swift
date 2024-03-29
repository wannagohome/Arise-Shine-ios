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
    private var optionView: PrayerOptionView?
    
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
    
    func removeOptionView() {
        self.optionView?.removeFromSuperview()
        self.optionView = nil
    }
    
    @IBAction func tapOpen(_ sender: Any) {
        if let prayer = self.prayer {
            self.delegate?.prayerShouldOpen(prayer)
        }
    }
    
    @IBAction func tapOption(_ sender: Any) {
        guard let prayer = self.prayer,
              self.optionView?.prayer != prayer else { return }
        
        guard self.optionView == nil else {
            self.removeOptionView()
            return
        }
        
        defer {
            self.optionView?.delegate = self
            self.delegate?.optionShouldShow(self, in: prayer)
            if let view = self.optionView {
                self.contentView.addSubview(view)
            }
        }
        
        self.optionView = PrayerOptionView(
            prayer: prayer,
            frame: CGRect(x: self.optionButton.frame.maxX - 90,
                          y: self.optionButton.frame.minY + 5,
                          width: 70, height: 50)
        )
    }
}

extension PrayerCell: PrayerOptionViewDelegate {
    func delete(prayer: Prayer) { self.delegate?.prayerShouldDelete(prayer: prayer) }
    func edit(prayer: Prayer) { self.delegate?.prayerShouldStartEdit(prayer: prayer) }
}

protocol PrayerDelegate: AnyObject {
    func prayerShouldOpen(_ prayer: Prayer)
    func optionShouldShow(_ cell: PrayerCell, in prayer: Prayer)
    func prayerShouldDelete(prayer: Prayer)
    func prayerShouldStartEdit(prayer: Prayer)
}
