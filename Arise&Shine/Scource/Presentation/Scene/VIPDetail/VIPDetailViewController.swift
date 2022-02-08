//
//  VIPDetailViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs
import RxSwift
import ReactorKit
import UIKit

enum VIPDetailPresentableAction {
    case viewWillAppear
}

protocol VIPDetailPresentableListener: class {
    var action: ActionSubject<VIPDetailPresentableAction> { get }
    var state: Observable<VIPDetailPresentableState> { get }
    var currentState: VIPDetailPresentableState { get }
}

final class VIPDetailViewController:
    BaseViewController,
    VIPDetailPresentable,
    VIPDetailViewControllable {
    
    // MARK: - Properties

    weak var listener: VIPDetailPresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
    }
    
    // MARK: - Inheritance
    
    override func attribute() {
        
    }
    
    // MARK: - Private methods
    
    private func bind(listener: VIPDetailPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: VIPDetailPresentableListener) {
        self.bindViewWillAppear(to: listener)
    }
    
    private func bindState(from listener: VIPDetailPresentableListener) {
        self.bindName(from: listener)
        self.bindPrayers(from: listener)
    }
}


extension VIPDetailViewController {
    static func initWithStoryBoard() -> VIPDetailViewController {
        VIPDetailViewController.withStoryboard(storyboard: .vipDetail)
    }
}

extension VIPDetailViewController {
    
    // MARK: - Binding Action
    
    func bindViewWillAppear(to listener: VIPDetailPresentableListener) {
        self.rx.viewWillAppear
            .map { _ in .viewWillAppear }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Binding State
    
    func bindName(from listener: VIPDetailPresentableListener) {
        listener.state.map { $0.vip.name }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.name.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func bindPrayers(from listener: VIPDetailPresentableListener) {
        listener.state.map { $0.prayers }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items) { tb, row, item in
                return UITableViewCell()
            }
            .disposed(by: self.disposeBag)
    }
}
