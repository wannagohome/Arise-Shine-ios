//
//  PlanDateCell.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import UIKit

final class PlanDateCell: UICollectionViewCell {
    
    //MARK: - Views
    private let dateLabel = UILabel()
    private let todayDot = CircleView(color: .gray)
    private let borderView = UIView()
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Internal Methods
    func configureCell(
        date: Int,
        isToday: Bool
    ) {
        self.dateLabel.text = String(date)
        self.todayDot.isHidden = !isToday
    }
    
    //MARK: - UI
    private func layout() {
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.todayDot)
        self.contentView.addSubview(self.borderView)
        
        self.dateLabel.snp.makeConstraints { m in
            m.centerX.equalToSuperview()
            m.centerY.equalToSuperview().offset(-16)
        }
        
        self.todayDot.snp.makeConstraints { m in
            m.top.equalTo(self.dateLabel.snp.bottom).offset(8)
            m.centerX.equalToSuperview()
            m.size.equalTo(CGSize(width: 8, height: 8))
        }
        
        self.borderView.snp.makeConstraints { m in
            m.top.equalToSuperview().offset(16)
            m.trailing.equalToSuperview()
            m.bottom.equalToSuperview().offset(-16)
            m.width.equalTo(1)
        }
    }
    
    private func attribute() {
        self.borderView.do {
            $0.backgroundColor = .systemGray5
        }
    }
}
