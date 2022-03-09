//
//  PlanViewController.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs
import RxSwift
import UIKit
import Then
import ReactorKit

enum PlanPresentableAction {
    case selectProgressingPlan
}

protocol PlanPresentableListener: AnyObject {
    var action: ActionSubject<PlanPresentableAction> { get }
}

final class PlanViewController:
    BaseViewController,
    PlanPresentable {

    weak var listener: PlanPresentableListener?
    
    let tabBarStackView = UIStackView()
    let inProgressTabButton = UIButton()
    let findTabButton = UIButton()
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Initialize
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
    }
    
    // MARK: - Inheritance
    override func layout() {
        self._layout()
    }
    
    override func attribute() {
        self._attribute()
    }
    
    // MARK: - Private methods
    private func setTabBarItem() {
        let item = UITabBarItem(title: "Bible",
                                image: UIImage(systemName: "books.vertical"),
                                tag: 1)
        item.badgeColor = .green
        tabBarItem = item
    }
    
    private func bind(listener: PlanPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: PlanPresentableListener) {
        self.subscribeTabbarActions()
    }
    
    private func bindState(from listener: PlanPresentableListener) {}
}

extension PlanViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InProgressReadingCell.description(),
                for: indexPath
            ) as! InProgressReadingCell
            cell.delegate = self
            return cell
        } else {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: PlanListCell.description(),
                for: indexPath
            )
        }
    }
}

extension PlanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        self.collectionView.bounds.size
    }
}

extension PlanViewController: InProgressDelegate {
    func select(index: IndexPath) {
        self.listener?.action.onNext(.selectProgressingPlan)
    }
}

extension PlanViewController: PlanViewControllable {
    func push(viewConroller: ViewControllable) {
        self.navigationController?.pushViewController(
            viewConroller.uiviewController,
            animated: true
        )
    }
    
    func pop(viewController: ViewControllable) {
        if self.presentedViewController === viewController.uiviewController {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

private extension PlanViewController {
    func subscribeTabbarActions() {
        self.inProgressTabButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.scrollToItem(
                    at: .init(row: 0, section: 0),
                    at: .left,
                    animated: true
                )
            })
            .disposed(by: self.disposeBag)
        
        self.findTabButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.scrollToItem(
                    at: .init(row: 1, section: 0),
                    at: .left,
                    animated: true
                )
            })
            .disposed(by: self.disposeBag)
    }
}
