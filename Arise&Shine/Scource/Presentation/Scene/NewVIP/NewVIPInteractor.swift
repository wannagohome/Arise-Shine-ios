//
//  ViewVIPInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs
import RxSwift
import ReactorKit

protocol NewVIPRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NewVIPPresentable: Presentable {
    var listener: NewVIPPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol NewVIPListener: AnyObject {
    func addNewVIP(of name: String,
                   description: String)
    func closeBibleNewVIP()
}

struct NewVIPPresentableState {
    var name: String?
    var description: String?
}

final class NewVIPInteractor:
    PresentableInteractor<NewVIPPresentable>,
    NewVIPInteractable,
    NewVIPPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = NewVIPPresentableAction
    typealias State = NewVIPPresentableState
    
    enum Mutaion {
        case setName(String)
        case setDescription(String)
    }
    
    var initialState: State
    
    // MARK: - Properties

    weak var router: NewVIPRouting?
    weak var listener: NewVIPListener?

    // MARK: - Initialization
    
    init(presenter: NewVIPPresentable,
         initialState: State) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .close:
            self.listener?.closeBibleNewVIP()
            return .empty()
            
        case .typeName(let name):
            return Observable.just(Mutaion.setName(name))
            
        case .typeDescription(let desc):
            return Observable.just(Mutaion.setDescription(desc))
            
        case .done:
            guard let name = self.currentState.name,
                  let desc = self.currentState.description else {
                return .empty()
            }
            self.listener?.addNewVIP(of: name, description: desc)
            self.listener?.closeBibleNewVIP()
            return .empty()
        }
    }
    
    func reduce(state: NewVIPPresentableState,
                mutation: Mutaion) -> NewVIPPresentableState {
        var newState = state
        
        switch mutation {
        case .setName(let name):
            newState.name = name
            
        case .setDescription(let desc):
            newState.description = desc
        }
        
        return newState
    }
}
