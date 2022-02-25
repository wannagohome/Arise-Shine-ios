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
    func attatchNewPrayer(with vip: VIP,
                          prayer: Prayer?)
    func detatchNewPrayer()
}

protocol VIPDetailPresentable: Presentable {
    var listener: VIPDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol VIPDetailListener: class {
    func closeVIPDetail()
}

struct VIPDetailPresentableState {
    let vip: VIP
    var prayers: [Prayer] = []
}

final class VIPDetailInteractor:
    PresentableInteractor<VIPDetailPresentable>,
    VIPDetailPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = VIPDetailPresentableAction
    typealias State = VIPDetailPresentableState
    
    enum Mutation {
        case setPrayers([Prayer])
        case addPrayer(Prayer)
        case open(Prayer)
        case delete(Prayer)
        case edit(Prayer)
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
            
        case .tapAdd:
            self.router?.attatchNewPrayer(with: self.currentState.vip,
                                          prayer: nil)
            return .empty()
            
        case .add(let prayer):
            return Observable.just(Mutation.addPrayer(prayer))
            
        case .close:
            self.listener?.closeVIPDetail()
            return .empty()
            
        case .open(let prayer):
            return Observable.just(Mutation.open(prayer))
            
        case .delegatePrayer(let prayer):
            return Observable.just(Mutation.delete(prayer))
            
        case .startEdit(let prayer):
            self.router?.attatchNewPrayer(with: self.currentState.vip,
                                          prayer: prayer)
            return .empty()
            
        case .edit(let prayer):
            return Observable.just(Mutation.edit(prayer))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newSate = state

        switch mutation {
        case .setPrayers(let prayers):
            newSate.prayers = prayers
            
        case .addPrayer(let prayer):
            newSate.prayers.append(prayer)
            
        case .open(let prayer):
            if let index = newSate.prayers.index(of: prayer) {
                newSate.prayers[index].isOpened = true
            }
            
        case .delete(let prayer):
            if let index = newSate.prayers.index(of: prayer) {
                newSate.prayers.remove(at: index)
            }
            
        case .edit(let prayer):
            if let index = newSate.prayers.index(of: prayer) {
                newSate.prayers[index].contents = prayer.contents
            }
        }
        
        return newSate
    }
}


extension VIPDetailInteractor: VIPDetailInteractable {
    func edit(prayer: Prayer) {
        self.action.onNext(.edit(prayer))
    }
    
    func closeNewPrayer() {
        self.router?.detatchNewPrayer()
    }
    
    func addNew(prayer: Prayer) {
        self.action.onNext(.add(prayer))
    }   
}
