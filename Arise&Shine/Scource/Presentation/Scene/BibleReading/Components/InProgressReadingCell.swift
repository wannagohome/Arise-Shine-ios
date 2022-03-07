//
//  InProgressReadingCell.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/06.
//

import UIKit

final class InProgressReadingCell: UICollectionViewCell {
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.layout()
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { m in
            m.edges.equalToSuperview().inset(8)
        }
    }
    
    private func attribute() {
        self.collectionView.do {
            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 4
                layout.scrollDirection = .vertical
            }
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
            $0.register(MyPlanCell.self, forCellWithReuseIdentifier: MyPlanCell.description())
        }
    }
}

extension InProgressReadingCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPlanCell.description(), for: indexPath) as! MyPlanCell
        cell.configure(title: "title")
        return cell
    }
}


extension InProgressReadingCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width, height: 64)
    }
}
