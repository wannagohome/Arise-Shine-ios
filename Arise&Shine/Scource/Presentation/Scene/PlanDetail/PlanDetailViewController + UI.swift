//
//  PlanDetailViewController + UI.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import UIKit

extension PlanDetailViewController {
    func _attribute() {
        self.dateCollectionView.do {
            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                layout.scrollDirection = .horizontal
            }
            $0.register(
                PlanDateCell.self,
                forCellWithReuseIdentifier: PlanDateCell.description()
            )
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
        }
    }
    
    func _layout() {
        self.view.addSubview(self.dateCollectionView)
        
        self.dateCollectionView.snp.makeConstraints { m in
            m.top.equalToSuperview()
            m.leading.equalToSuperview()
            m.trailing.equalToSuperview()
            m.height.equalTo(self.view.bounds.width / 5)
        }
    }
}
