//
//  SettingViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/14.
//

import RIBs
import RxSwift
import RxCocoa
import ReactorKit
import UIKit

enum SettingPresentableAction {}

protocol SettingPresentableListener: AnyObject {
    var action: ActionSubject<SettingPresentableAction> { get }
    var state: Observable<SettingPresentableState> { get }
    var currentState: SettingPresentableState { get }
    
    func pushSelectPlan()
}

final class SettingViewController:
    BaseViewController,
    SettingPresentable {

    // MARK: - Properties
    
    weak var listener: SettingPresentableListener?
    
    //MARK: - Views
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initialization
    
    override func initialize() {
        self.setTabBarItem()
    }
    
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
    
    private func setTabBarItem() {
        let item = UITabBarItem(title: "Setting",
                                image: UIImage(systemName: "gear"),
                                tag: 1)
        item.badgeColor = .green
        tabBarItem = item
    }
    
    private func bind(listener: SettingPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: SettingPresentableListener) {
        self.bindSelectTableView(to: listener)
    }
    
    private func bindState(from listener: SettingPresentableListener) {
        self.bindTableView(from: listener)
    }
}

extension SettingViewController: SettingViewControllable {
    func push(viewController: ViewControllable) {
        self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }
    
    func pop(viewController: ViewControllable) {
        if self.presentedViewController === viewController.uiviewController {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension SettingViewController {
    static func initWithStoryBoard() -> SettingViewController {
        SettingViewController.withStoryboard(storyboard: .setting)
    }
}

extension SettingViewController {
    
    // MARK: - Binding Action
    
    func bindSelectTableView(to listener: SettingPresentableListener) {
        self.tableView.rx.itemSelected
            .filter { $0.row == 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.pushSelectPlan()
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Biding State
    
    func bindTableView(from listener: SettingPresentableListener) {
        listener.state.map { $0.tableItems }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items) { tb, row, items in
                let cell = tb.dequeueReusableCell(withIdentifier: UITableViewCell.description(),
                                                  for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = items
                return cell
            }
            .disposed(by: self.disposeBag)
    }
}
