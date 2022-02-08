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

protocol NewVIPListener: class {
    func addNewVIP(of name: String)
    func closeBibleNewVIP()
}

struct NewVIPPresentableState {}

final class NewVIPInteractor:
    PresentableInteractor<NewVIPPresentable>,
    NewVIPInteractable,
    NewVIPPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = NewVIPPresentableAction
    typealias State = NewVIPPresentableState
    
    enum Mutaion {}
    
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
            
        case .done(let name):
            self.listener?.addNewVIP(of: name)
            self.listener?.closeBibleNewVIP()
            return .empty()
        }
    }
}
