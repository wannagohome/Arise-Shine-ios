//
//  BibleViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs
import ReactorKit
import RxSwift
import RxCocoa
import RxAppState
import PanModal

import UIKit

enum BiblePresentableAction {
    case turnChapter(BibleChapter)
    case tapTitle
    case tapFont
    case selectVerse(Int)
    case resetSelecting
    case fonSizeUp
    case fonSizeDown
}

protocol BiblePresentableListener: class {
    var action: ActionSubject<BiblePresentableAction> { get }
    var state: Observable<BiblePresentableState> { get }
    var currentState: BiblePresentableState { get }
}

final class BibleViewController:
    BaseViewController,
    BiblePresentable {
    
    // MARK: - Properties
    
    weak var listener: BiblePresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fontButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    
    // MARK: - Initialization
    
    override func initialize() {
        self.setTabBarItem()
        self.setNavBarItem()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Inheritance
    
    override func attribute() {
        self.tableView.register(UINib(nibName: "BibleVerseCell",
                                      bundle: nil),
                                forCellReuseIdentifier: BibleVerseCell.description())
        self.titleButton.setTitleColor(.black, for: .normal)
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.titleButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
    }
    
    // MARK: - Private methods
    
    private func setTabBarItem() {
        let item = UITabBarItem(title: "Bible",
                                image: UIImage(systemName: "book"),
                                tag: 1)
        item.badgeColor = .green
        tabBarItem = item
    }
    
    private func setNavBarItem() {
        self.navigationItem.titleView = self.titleButton
        
    }
    
    private func bind(listener: BiblePresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: BiblePresentableListener) {
        self.bindTitleTap(to: listener)
        self.bindFontTap(to: listener)
        self.bindTableSelect(to: listener)
    }
    
    private func bindState(from listener: BiblePresentableListener) {
        self.bindVerses(from: listener)
        self.bindBookName(from: listener)
    }
}

extension BibleViewController {
    static func initWithStoryBoard() -> BibleViewController {
        BibleViewController.withStoryboard(storyboard: .bible)
    }
}

extension BibleViewController: BibleViewControllable {
    func present(viewController: ViewControllable) {
        if let modal = viewController as? UIViewController & PanModalPresentable {
            self.presentPanModal(modal)
        } else {
            self.present(viewController.uiviewController, animated: true)
        }
    }
    
    func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func addSelecting(viewController: ViewControllable) {
        guard let optionView = viewController.uiviewController.view else { return }
        self.tabBarController?.tabBar.isHidden = true
        self.addChild(viewController.uiviewController)
        self.view.addSubview(optionView)
        
        optionView.snp.makeConstraints { m in
            m.leading.equalToSuperview()
            m.trailing.equalToSuperview()
            m.bottom.equalToSuperview()
            m.height.equalTo(100)
        }
    }
    
    func removeSelecting(viewController: ViewControllable) {
        self.tabBarController?.tabBar.isHidden = false
        viewController.uiviewController.willMove(toParent: nil)
        viewController.uiviewController.removeFromParent()
        viewController.uiviewController.view.removeFromSuperview()
    }
}

// MARK: - UIScrollViewDelegate

extension BibleViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let isGoingDown = velocity.y > 0
        let navBarHeight = self.navigationController!.navigationBar.frame.height
        let navInsets = UIEdgeInsets(top: isGoingDown ? 20 : 0, left: 0, bottom: 0, right: 0)
        
        self.tabBarController?.setTabBarHidden(isGoingDown, animated: true)
        self.titleButton.titleEdgeInsets = navInsets
        self.fontButton.titleEdgeInsets = navInsets
        self.topConstraint.constant = isGoingDown ? -navBarHeight / 2 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.transform =
                .init(translationX: 0, y: isGoingDown ? -navBarHeight / 2 : 0)
            self.titleButton.layoutIfNeeded()
            self.fontButton.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
}

private extension BibleViewController {
    
    // MARK: - Binding Action
    
    func bindTitleTap(to listener: BiblePresentableListener) {
        self.titleButton.rx.tap
            .map { _ in .tapTitle}
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindFontTap(to listener: BiblePresentableListener) {
        self.fontButton.rx.tap
            .map { _ in .tapFont }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindTableSelect(to listener: BiblePresentableListener) {
        self.tableView.rx.itemSelected
            .map { $0.row }
            .map(BiblePresentableAction.selectVerse)
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Biding State
    
    func bindVerses(from listener: BiblePresentableListener) {
        listener.state.compactMap { $0.verses }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items) { tb, row, item in
                let cell = tb.dequeueReusableCell(
                    withIdentifier: BibleVerseCell.description(),
                    for: IndexPath(row: row, section: 0)
                ) as! BibleVerseCell
                
                cell.numberLabel.text = "\(row+1)"
                cell.verseLabel.font = .systemFont(ofSize: CGFloat(item.fontSize))
                cell.verse = item
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    func bindBookName(from listener: BiblePresentableListener) {
        listener.state
            .compactMap { $0.currentChapter.bookName! + "  \($0.currentChapter.chapter)장" }
            .do(afterNext: { [weak self] _ in
                self?.titleButton.sizeToFit()
            })
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.titleButton.rx.title())
            .disposed(by: self.disposeBag)
    }
    
}
