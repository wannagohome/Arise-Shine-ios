//
//  PlanPresetCell.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import UIKit

final class PlanPresetCell: UICollectionViewCell {
    
    //MARK: - Views
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String) {
        self.titleLabel.text = title
    }
    
    private func layout() {
        self.contentView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { m in
            m.center.equalToSuperview()
        }
    }
    
    private func attribute() {
        self.contentView.backgroundColor = .systemGray5
    }
}
