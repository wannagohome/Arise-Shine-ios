//
//  BibleFontInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/26.
//

import RIBs
import RxSwift
import ReactorKit

protocol BibleFontRouting: ViewableRouting {}

protocol BibleFontPresentable: Presentable {
    var listener: BibleFontPresentableListener? { get set }
}

protocol BibleFontListener: class {
    func sizeUp()
    func sizeDown()
    func closeBibleFont()
}

struct BibleFontPresentableState {}

final class BibleFontInteractor:
    PresentableInteractor<BibleFontPresentable>,
    BibleFontInteractable,
    BibleFontPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = BibleFontPresentableAction
    typealias State = BibleFontPresentableState
    
    enum Mutaion {}
    
    var initialState: State
    
    // MARK: - Properties

    weak var router: BibleFontRouting?
    weak var listener: BibleFontListener?
    
    // MARK: - Initialization

    init(presenter: BibleFontPresentable,
         initialState: State) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .sizeUp:
            self.listener?.sizeUp()
            return .empty()
            
        case .sizeDown:
            self.listener?.sizeDown()
            return .empty()
            
        case .close:
            self.listener?.closeBibleFont()
            return .empty()
        }
    }
}
