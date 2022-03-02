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
    case open(Prayer)
    case delegatePrayer(Prayer)
    case startEdit(Prayer)
    case edit(Prayer)
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
        self.tableView.register(UINib(nibName: "PrayerCell", bundle: nil),
                                forCellReuseIdentifier: PrayerCell.description())
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 70
        self.tableView.delegate = self
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
            .drive(self.tableView.rx.items) { [weak self] tb, row, item in
                let cell = tb.dequeueReusableCell(withIdentifier: PrayerCell.description()) as! PrayerCell
                cell.configure(by: item)
                cell.delegate = self
                return cell
            }
            .disposed(by: self.disposeBag)
    }
}

extension VIPDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PrayerCell {
            cell.removeOptionView()
        }
    }
}

extension VIPDetailViewController: PrayerDelegate {
    func prayerShouldDelete(prayer: Prayer) {
        self.listener?.action.onNext(.delegatePrayer(prayer))
    }
    
    func prayerShouldStartEdit(prayer: Prayer) {
        self.listener?.action.onNext(.startEdit(prayer))
    }
    
    func prayerShouldOpen(_ prayer: Prayer) {
        self.listener?.action.onNext(.open(prayer))
    }
    
    func optionShouldShow(_ cell: PrayerCell, in prayer: Prayer) {
        self.tableView.visibleCells
            .filter { $0 != cell }
            .compactMap { $0 as? PrayerCell }
            .forEach { $0.removeOptionView() }
    }
}
