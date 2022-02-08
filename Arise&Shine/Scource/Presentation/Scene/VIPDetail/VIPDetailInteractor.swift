//
//  VIPDetailInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs
import RxSwift
import ReactorKit

protocol VIPDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol VIPDetailPresentable: Presentable {
    var listener: VIPDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol VIPDetailListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

struct VIPDetailPresentableState {
    let vip: VIP
    var prayers: [Prayer] = []
}

final class VIPDetailInteractor:
    PresentableInteractor<VIPDetailPresentable>,
    VIPDetailInteractable,
    VIPDetailPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = VIPDetailPresentableAction
    typealias State = VIPDetailPresentableState
    
    enum Mutation {
        case setPrayers([Prayer])
    }
    
    var initialState: State
    
    // MARK: - Properties
    
    weak var router: VIPDetailRouting?
    weak var listener: VIPDetailListener?
    private let db = PrayerManager()
    
    // MARK: - Initialization
    
    init(presenter: VIPDetailPresentable,
         initialState: State) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            guard let id = self.currentState.vip.id else {
                return .empty()
            }
            return Observable.just(Mutation.setPrayers(db.selectAll(of: id)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newSate = state

        switch mutation {
        case .setPrayers(let prayers):
            newSate.prayers = prayers
        }
        
        return newSate
    }
}
