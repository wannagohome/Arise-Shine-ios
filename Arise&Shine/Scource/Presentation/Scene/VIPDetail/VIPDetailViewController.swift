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
import PanModal

enum VIPDetailPresentableAction {
    case viewWillAppear
    case close
    case tapAdd
    case add(Prayer)
}

protocol VIPDetailPresentableListener: class {
    var action: ActionSubject<VIPDetailPresentableAction> { get }
    var state: Observable<VIPDetailPresentableState> { get }
    var currentState: VIPDetailPresentableState { get }
}

final class VIPDetailViewController:
    BaseViewController,
    VIPDetailPresentable {
    
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    }
    
    // MARK: - Private methods
    
    private func bind(listener: VIPDetailPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: VIPDetailPresentableListener) {
        self.bindViewWillAppear(to: listener)
        self.bindTapAdd(to: listener)
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

extension VIPDetailViewController: VIPDetailViewControllable {
    func present(viewController: ViewControllable) {
        if let modal = viewController as? UIViewController & PanModalPresentable {
            self.presentPanModal(modal)
        } else {
            self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
        }
    }
    
    func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true, completion: nil)
        }
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
    
    func bindTapAdd(to listener: VIPDetailPresentableListener) {
        self.addButton.rx.tap
            .map { _ in .tapAdd }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindViewDidDisappear(to listener: NewVIPPresentableListener,
                              isDismissing: Bool) {
        self.rx.viewDidDisappear
            .filter { _ in isDismissing }
            .map { _ in .close }
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
                let cell = tb.dequeueReusableCell(withIdentifier: UITableViewCell.description())!
                cell.textLabel?.text = item.contents
                return cell
            }
            .disposed(by: self.disposeBag)
    }
}
