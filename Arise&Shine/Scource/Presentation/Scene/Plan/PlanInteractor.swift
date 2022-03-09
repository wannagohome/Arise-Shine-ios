//
//  PlanInteractor.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs
import RxSwift
import ReactorKit

protocol PlanRouting: ViewableRouting {
    func attatchPlanDetail()
    func detachPlanDeatil()
}

protocol PlanPresentable: Presentable {
    var listener: PlanPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PlanListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

struct PlanPresentableState {
    
}

final class PlanInteractor:
    PresentableInteractor<PlanPresentable>,
    PlanPresentableListener,
    Reactor {
    
    //MARK: - Reactor
    typealias Action = PlanPresentableAction
    typealias State = PlanPresentableState
    var initialState = State()
    enum Mutaion {}
    
    //MARK: - Properties
    weak var router: PlanRouting?
    weak var listener: PlanListener?

    // MARK: - Initialization
    override init(presenter: PlanPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    //MARK: - Reactor
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .selectProgressingPlan:
            self.router?.attatchPlanDetail()
            return .empty()
        }
    }
}

extension PlanInteractor: PlanInteractable {
    func popPlanDetail() {
        self.router?.detachPlanDeatil()
    }
}
