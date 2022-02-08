//
//  VIPHeader.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/29.
//

import UIKit

class VIPHeader: UITableViewHeaderFooterView {

    let label = UILabel()
    let addButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.addButton)
        self.contentView.backgroundColor = .clear
        self.label.snp.makeConstraints { m in
            m.centerY.equalToSuperview()
            m.leading.equalToSuperview().offset(15)
        }
        self.addButton.snp.makeConstraints { m in
            m.centerY.equalTo(self.label)
            m.trailing.equalToSuperview().offset(-25)
        }
        self.addButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        self.addButton.tintColor = .black
        self.label.font = .systemFont(ofSize: 30, weight: .heavy)
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        self.addButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
