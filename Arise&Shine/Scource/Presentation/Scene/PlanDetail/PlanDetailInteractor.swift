//
//  PlanDetailInteractor.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import RIBs
import RxSwift
import ReactorKit

protocol PlanDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PlanDetailPresentable: Presentable {
    var listener: PlanDetailPresentableListener? { get set }
}

protocol PlanDetailListener: AnyObject {
    func popPlanDetail()
}

struct PlanDetailPresentableState {}

final class PlanDetailInteractor:
    PresentableInteractor<PlanDetailPresentable>,
    PlanDetailInteractable,
    PlanDetailPresentableListener,
    Reactor {
    
    //MARK: - Reactor
    typealias Action = PlanDetailPresentableAction
    typealias State = PlanDetailPresentableState
    var initialState = State()
    
    //MARK: - Properties
    weak var router: PlanDetailRouting?
    weak var listener: PlanDetailListener?
    
    //MARK: - Initialization
    override init(presenter: PlanDetailPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    //MARK: - Reactor
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .pop:
            self.listener?.popPlanDetail()
            return .empty()
        }
    }
}
