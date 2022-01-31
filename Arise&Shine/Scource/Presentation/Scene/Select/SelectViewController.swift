//
//  SelectViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs
import ReactorKit
import RxSwift
import RxCocoa
import UIKit

enum SelectPresentableAction {
    case selectBook(Int)
    case selectChapter(Int)
    case close
}

protocol SelectPresentableListener: class {
    var currentChapter: BibleChapter { get }
    var action: ActionSubject<SelectPresentableAction> { get }
    var state: Observable<SelectPresentableState> { get }
    var currentState: SelectPresentableState { get }
}

final class SelectViewController:
    BaseViewController,
    SelectPresentable,
    SelectViewControllable {
    
    // MARK: - Properties
    
    weak var listener: SelectPresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var divisionTable: UITableView!
    @IBOutlet weak var bookTable: UITableView!
    @IBOutlet weak var chapterTable: UITableView!
    
    // MARK: - Initialization
    
    override func initialize() {
        self.modalPresentationStyle = .pageSheet
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.bind(listener: self.listener)
    }
    
    // MARK: - Inheritance
    
    override func attribute() {
        self.divisionTable.register(UITableViewCell.self,
                                    forCellReuseIdentifier: UITableViewCell.description())
        self.bookTable.register(UITableViewCell.self,
                                forCellReuseIdentifier: UITableViewCell.description())
        self.chapterTable.register(UITableViewCell.self,
                                   forCellReuseIdentifier: UITableViewCell.description())
    }
    
    // MARK: - Private methods
    
    private func bind(listener: SelectPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: SelectPresentableListener) {
        self.bindSelectBook(to: listener)
        self.bindSelectChapter(to: listener)
        self.bindViewDidDisappear(to: listener,
                                  isDismissing: self.isDismissing)
    }
    
    private func bindState(from listener: SelectPresentableListener) {
        self.bindDivision()
        self.bindBooks(from: listener)
        self.bindChapters(from: listener)
    }
}

extension SelectViewController {
    static func initWithStoryBoard() -> SelectViewController {
        SelectViewController.withStoryboard(storyboard: .select)
    }
}


private extension SelectViewController {
    
    // MARK: - Binding Action
    
    func bindSelectBook(to listener: SelectPresentableListener) {
        self.bookTable.rx.itemSelected
            .map { $0.item + 1 }
            .map { .selectBook($0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindSelectChapter(to listener: SelectPresentableListener) {
        self.chapterTable.rx.itemSelected
            .map { $0.item + 1 }
            .map { .selectChapter($0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindViewDidDisappear(to listener: SelectPresentableListener,
                              isDismissing: Bool) {
        self.rx.viewDidDisappear
            .filter { _ in isDismissing }
            .map { _ in .close }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Biding State
    
    func bindDivision() {
        Driver.just(["구약", "신약"])
            .drive(self.divisionTable.rx.items) { tb, row, item in
                let cell = tb.dequeueReusableCell(withIdentifier: UITableViewCell.description(),
                                                  for: IndexPath(item: row, section: 0))
                cell.textLabel?.text = item
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    func bindBooks(from listener: SelectPresentableListener) {
        Driver.just(BibleManager(of: .kor).getBookNames() ?? [])
            .drive(self.bookTable.rx.items) { tb, row, item in
                let cell = tb.dequeueReusableCell(withIdentifier: UITableViewCell.description(),
                                                  for: IndexPath(item: row, section: 0))
                cell.textLabel?.text = item
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    func bindChapters(from listener: SelectPresentableListener) {
        self.listener?.state.compactMap { $0.chapters }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.chapterTable.rx.items) { tb, row, item in
                let cell = tb.dequeueReusableCell(withIdentifier: UITableViewCell.description(),
                                                  for: IndexPath(item: row, section: 0))
                cell.textLabel?.text = item
                return cell
            }
            .disposed(by: self.disposeBag)
    }
}
