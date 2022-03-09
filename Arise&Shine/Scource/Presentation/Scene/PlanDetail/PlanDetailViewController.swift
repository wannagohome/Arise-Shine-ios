//
//  PlanDetailViewController.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import RIBs
import RxSwift
import UIKit
import ReactorKit

enum PlanDetailPresentableAction {
    case pop
}

protocol PlanDetailPresentableListener: AnyObject {
    var action: ActionSubject<PlanDetailPresentableAction> { get }
    var state: Observable<PlanDetailPresentableState> { get }
    var currentState: PlanDetailPresentableState { get }
}

final class PlanDetailViewController:
    BaseViewController,
    PlanDetailPresentable,
    PlanDetailViewControllable {
    
    weak var listener: PlanDetailPresentableListener?
    
    //MARK: - Views
    let dateCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    //MARK: - UI
    override func layout() {
        self._layout()
    }
    
    override func attribute() {
        self._attribute()
    }
}


extension PlanDetailViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlanDateCell.description(),
            for: indexPath
        ) as! PlanDateCell
        cell.configureCell(date: indexPath.row, isToday: true)
        return cell
    }
}


extension PlanDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let lengh = collectionView.bounds.height
        return .init(width: lengh, height: lengh)
    }
}
