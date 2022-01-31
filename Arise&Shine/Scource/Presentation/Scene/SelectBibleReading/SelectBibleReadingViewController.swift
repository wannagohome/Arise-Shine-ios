//
//  SelectBibleReadingViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs
import RxSwift
import ReactorKit
import UIKit
import Toaster

enum SelectBibleReadingPresentableAction {
    case selectSchedule(with: BibleReadingSchedule)
    case pop
}

protocol SelectBibleReadingPresentableListener: class {
    var action: ActionSubject<SelectBibleReadingPresentableAction> { get }
    var state: Observable<SelectBibleReadingPresentableState> { get }
    var currentState: SelectBibleReadingPresentableState { get }
}

final class SelectBibleReadingViewController:
    BaseViewController,
    SelectBibleReadingPresentable,
    SelectBibleReadingViewControllable {
    
    // MARK: - Properties

    weak var listener: SelectBibleReadingPresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Inheritance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
    }
    
    override func attribute() {
        self.tableView.register(UINib(nibName: "BibleReadingCell",
                                      bundle: nil),
                                forCellReuseIdentifier: BibleReadingCell.description())
    }
    
    // MARK: - Private methods
    
    private func bind(listener: SelectBibleReadingPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
        self.bindViewDidDisappear(to: listener,
                                  isDismissing: self.isDismissing)
    }
    
    private func bindActions(to listener: SelectBibleReadingPresentableListener) {
        self.bindTableSelect(to: listener)
    }
    
    private func bindState(from listener: SelectBibleReadingPresentableListener) {
        self.bindSchedules(from: listener)
        self.bindToastMessage(from: listener)
    }
}

extension SelectBibleReadingViewController {
    static func initWithStoryBoard() -> SelectBibleReadingViewController {
        SelectBibleReadingViewController.withStoryboard(storyboard: .selectBibleReading)
    }
}


private extension SelectBibleReadingViewController {
    
    // MARK: - Binding Action
    
    func bindTableSelect(to listener: SelectBibleReadingPresentableListener) {
        self.tableView.rx.modelSelected(BibleReadingSchedule.self)
            .map { .selectSchedule(with: $0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindViewDidDisappear(to listener: SelectBibleReadingPresentableListener,
                              isDismissing: Bool) {
        self.rx.viewDidDisappear
            .filter { _ in isDismissing }
            .map { _ in .pop }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Biding State
    
    func bindSchedules(from listener: SelectBibleReadingPresentableListener) {
        listener.state.map { $0.schedules }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items) { tb, row, item in
                let cell = tb.dequeueReusableCell(withIdentifier: BibleReadingCell.description(),
                                                  for: IndexPath(row: row, section: 0)) as! BibleReadingCell
                cell.schedule = item
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    func bindToastMessage(from listener: SelectBibleReadingPresentableListener) {
        listener.state.map { $0.isShowingMessage }
            .filter { $0 }
            .withLatestFrom(listener.state.map { $0.toastMessage })
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                Toast(text: $0).show()
            })
            .disposed(by: self.disposeBag)
            
    }
}
