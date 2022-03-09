//
//  PlanListCell.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/06.
//

import UIKit

final class PlanListCell: UICollectionViewCell {
    
    //MARK: - Views
    private let presetCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
     
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.layout()
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func layout() {
        self.contentView.addSubview(self.presetCollectionView)
        
        self.presetCollectionView.snp.makeConstraints { m in
            m.edges.equalTo(self.contentView.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func attribute() {
        self.presetCollectionView.do {
            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
                layout.minimumLineSpacing = 8
            }
            $0.register(
                PlanPresetCell.self,
                forCellWithReuseIdentifier: PlanPresetCell.description()
            )
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
        }
    }
}

extension PlanListCell: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlanPresetCell.description(),
            for: indexPath
        ) as! PlanPresetCell
        cell.configureCell(title: "모세오경")
        return cell
    }
}

extension PlanListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(
            width: collectionView.bounds.width / 3 * 2,
            height: 64
        )
    }
}
