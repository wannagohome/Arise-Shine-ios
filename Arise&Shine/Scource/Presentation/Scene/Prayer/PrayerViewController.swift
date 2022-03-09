//
//  PrayerViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/28.
//

import RIBs
import RxSwift
import ReactorKit
import UIKit
import RxDataSources
import PanModal

enum PrayerPresentableAction {
    case add(String, String)
    case viewWillAppear
    case tapNewVIP
    case selectTable(VIP)
}

protocol PrayerPresentableListener: AnyObject {
    var action: ActionSubject<PrayerPresentableAction> { get }
    var state: Observable<PrayerPresentableState> { get }
    var currentState: PrayerPresentableState { get }
}

final class PrayerViewController:
    BaseViewController,
    PrayerPresentable {
    
    typealias VIPDataSource = RxTableViewSectionedReloadDataSource<VIPSection>
    
    // MARK: - Properties
    weak var listener: PrayerPresentableListener?
    let dataSource = VIPDataSource {
        dataSource, tb, indexPath, item -> UITableViewCell in
        let cell = tb.dequeueReusableCell(withIdentifier: VIPCell.description()) as! VIPCell
        cell.name.text = item.name
        cell.vipDescription.text = item.description
        return cell
    }
    
    // MARK: - Views
    let tableView = UITableView(frame: .zero, style: .grouped)
    let createCellButton = UIButton()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setTabBarItem()
        self.setNavBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        self.bind(listener: self.listener)
    }
    
    //MARK: - UI
    override func layout() {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { m in
            m.edges.equalTo(self.view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15))
        }
    }
    
    override func attribute() {
        self.tableView.do {
            $0.register(
                UINib(nibName: "VIPCell", bundle: nil),
                forCellReuseIdentifier: VIPCell.description()
            )
            $0.backgroundColor = .clear
        }
        self.createCellButton.do {
            $0.tintColor = .black
            $0.setImage(.init(systemName: "plus"), for: .normal)
        }
    }
    
    private func setTabBarItem() {
        let item = UITabBarItem(title: "Prayer",
                                image: UIImage(systemName: "hands.sparkles"),
                                tag: 1)
        item.badgeColor = .green
        self.tabBarItem = item
    }
    
    private func setNavBarItem() {
        self.navigationItem.rightBarButtonItem
            = UIBarButtonItem(customView: self.createCellButton)
    }
    
    // MARK: - Private methods
    private func bind(listener: PrayerPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: PrayerPresentableListener) {
        self.bindViewWillAppear(to: listener)
        self.bindTableSelect(to: listener)
    }
    
    private func bindState(from listener: PrayerPresentableListener) {
        self.bindVIPs(from: listener, with: self.dataSource)
    }
}

extension PrayerViewController: PrayerViewControllable {
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

extension PrayerViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = VIPHeader()
        header.label.text = "내 VIP"
        if let listener = self.listener {
            header.addButton.rx.tap
                .map { _ in .tapNewVIP }
                .bind(to: listener.action)
                .disposed(by: self.disposeBag)
        }
        
        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        70
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        60
    }
}


extension PrayerViewController {
    
    // MARK: - Binding Action
    func bindViewWillAppear(to listener: PrayerPresentableListener) {
        self.rx.viewWillAppear
            .map { _ in .viewWillAppear }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindTableSelect(to listener: PrayerPresentableListener) {
        self.tableView.rx.modelSelected(VIP.self)
            .map { .selectTable($0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Biding State
    func bindVIPs(from listener: PrayerPresentableListener,
                  with dataSource: VIPDataSource) {
        
        listener.state.map { $0.sections }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}
