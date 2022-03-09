//
//  SelectPlanViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs
import RxSwift
import ReactorKit
import UIKit
import Toaster

enum SelectPlanPresentableAction {
    case selectSchedule(with: Schedule)
    case pop
}

protocol SelectPlanPresentableListener: AnyObject {
    var action: ActionSubject<SelectPlanPresentableAction> { get }
    var state: Observable<SelectPlanPresentableState> { get }
    var currentState: SelectPlanPresentableState { get }
}

final class SelectPlanViewController:
    BaseViewController,
    SelectPlanPresentable,
    SelectPlanViewControllable {
    
    // MARK: - Properties

    weak var listener: SelectPlanPresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Inheritance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
    }
    
    override func attribute() {
        self.tableView.register(UINib(nibName: "PlanCell",
                                      bundle: nil),
                                forCellReuseIdentifier: PlanCell.description())
    }
    
    // MARK: - Private methods
    
    private func bind(listener: SelectPlanPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
        self.bindViewDidDisappear(to: listener,
                                  isDismissing: self.isDismissing)
    }
    
    private func bindActions(to listener: SelectPlanPresentableListener) {
        self.bindTableSelect(to: listener)
    }
    
    private func bindState(from listener: SelectPlanPresentableListener) {
        self.bindSchedules(from: listener)
        self.bindToastMessage(from: listener)
    }
}

extension SelectPlanViewController {
    static func initWithStoryBoard() -> SelectPlanViewController {
        SelectPlanViewController.withStoryboard(storyboard: .selectPlan)
    }
}


private extension SelectPlanViewController {
    
    // MARK: - Binding Action
    
    func bindTableSelect(to listener: SelectPlanPresentableListener) {
        self.tableView.rx.modelSelected(Schedule.self)
            .map { .selectSchedule(with: $0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindViewDidDisappear(to listener: SelectPlanPresentableListener,
                              isDismissing: Bool) {
        self.rx.viewDidDisappear
            .filter { _ in isDismissing }
            .map { _ in .pop }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Biding State
    
    func bindSchedules(from listener: SelectPlanPresentableListener) {
        listener.state.map { $0.schedules }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items) { tb, row, item in
                let cell = tb.dequeueReusableCell(withIdentifier: PlanCell.description(),
                                                  for: IndexPath(row: row, section: 0)) as! PlanCell
                cell.schedule = item
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    func bindToastMessage(from listener: SelectPlanPresentableListener) {
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
