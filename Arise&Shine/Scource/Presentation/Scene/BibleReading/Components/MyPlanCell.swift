//
//  MyPlanCell.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/06.
//

import UIKit

final class MyPlanCell: UICollectionViewCell {
    
    //MARK: - Views
    private let titleLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .bar)
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
        self.attribute()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
        self.progressView.progress = 0.1
    }
    
    //MARK: - Private Methods
    private func layout() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.progressView)
        
        self.titleLabel.snp.makeConstraints { m in
            m.top.equalToSuperview().offset(8)
            m.leading.equalToSuperview().offset(16)
        }
        
        self.progressView.snp.makeConstraints {  m in
            m.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            m.leading.equalToSuperview().offset(16)
            m.trailing.equalToSuperview().offset(-48)
            m.height.equalTo(8)
        }
    }
    
    private func attribute() {
        self.contentView.backgroundColor = .systemGray6
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.progressView.do {
            $0.progressTintColor = .gray
            $0.backgroundColor = .white
        }
    }
}


final class FullWidthCollectionViewLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell,
               let newFrame = self.layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                layoutAttributes.frame = newFrame
            }
        })
        return layoutAttributesObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else {
            fatalError()
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }

}
