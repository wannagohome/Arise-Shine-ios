//
//  PrayerOptionView.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/02/23.
//

import UIKit

final class PrayerOptionView: UIView {
    
    // MARK: - Properties
    
    private let prayer: Prayer
    weak var delegate: PrayerOptionViewDelegate?
    
    // MARK: - Views
    
    private let deleteButton = UIButton()
    private let editButton = UIButton()
    
    
    // MARK: - Initialize
    
    init(prayer: Prayer, frame: CGRect) {
        defer {
            self.attribute()
            self.layout()
            self.layer.borderWidth = 1
            self.backgroundColor = .white
        }
        self.prayer = prayer
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func layout() {
        self.addSubview(self.deleteButton)
        self.addSubview(self.editButton)
        
        let size = CGSize(width: self.frame.width, height: self.frame.height / 2)
        self.deleteButton.frame = CGRect(origin: .zero, size: size)
        self.editButton.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.height / 2), size: size)
    }
    
    private func attribute() {
        self.deleteButton.setTitle("삭제", for: .normal)
        self.deleteButton.setTitleColor(.black, for: .normal)
        self.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        self.editButton.setTitle("수정", for: .normal)
        self.editButton.setTitleColor(.black, for: .normal)
        self.editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
    }
    
    @objc private func deleteAction() {
        self.delegate?.delete(prayer: self.prayer)
    }
    
    @objc private func editAction() {
        self.delegate?.edit(prayer: self.prayer)
    }
}


protocol PrayerOptionViewDelegate: class {
    func delete(prayer: Prayer)
    func edit(prayer: Prayer)
}
