//
//  BibleReading+UI.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/07.
//

import UIKit


extension BibleReadingViewController {
    func _layout() {
        self.view.addSubview(self.tabBarStackView)
        self.tabBarStackView.addArrangedSubview(self.inProgressTabButton)
        self.tabBarStackView.addArrangedSubview(self.findTabButton)
        self.view.addSubview(self.collectionView)
        
        self.tabBarStackView.snp.makeConstraints { m in
            m.top.equalTo(self.view.safeAreaLayoutGuide)
            m.leading.equalTo(self.view.safeAreaLayoutGuide)
            m.trailing.equalTo(self.view.safeAreaLayoutGuide)
            m.height.equalTo(48)
        }
        
        self.collectionView.snp.makeConstraints { m in
            m.top.equalTo(self.tabBarStackView.snp.bottom)
            m.leading.equalTo(self.view.safeAreaLayoutGuide)
            m.trailing.equalTo(self.view.safeAreaLayoutGuide)
            m.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func _attribute() {
        self.tabBarStackView.do {
            $0.distribution = .fillEqually
        }
        
        self.inProgressTabButton.do {
            $0.setTitle("진행중인 통독계획", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        
        self.findTabButton.do {
            $0.setTitle("통독 계획 찾기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        
        self.collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.isPagingEnabled = true
            $0.bounces = false
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
            }
            $0.register(
                InProgressReadingCell.self,
                forCellWithReuseIdentifier: InProgressReadingCell.description()
            )
            $0.register(
                FindingReadCell.self,
                forCellWithReuseIdentifier: FindingReadCell.description()
            )
        }
    }
}
