//
//  SelectInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import Foundation
import RIBs
import RxSwift
import ReactorKit

protocol SelectRouting: ViewableRouting {}

protocol SelectPresentable: Presentable {
    var listener: SelectPresentableListener? { get set }
}

protocol SelectListener: class {
    func select(chapter: BibleChapter)
    func closeBibleSelect()
}

final class SelectInteractor:
    PresentableInteractor<SelectPresentable>,
    SelectInteractable,
    SelectPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = SelectPresentableAction
    typealias State = SelectPresentableState
    
    enum Mutaion {
        case setCurrentBook(Int)
    }
    
    var initialState: SelectPresentableState
    
    // MARK: - Properties

    weak var router: SelectRouting?
    weak var listener: SelectListener?
    
    let currentChapter: BibleChapter
    
    // MARK: - Initialization
    
    init(presenter: SelectPresentable,
         currentChapter: BibleChapter) {
        
        self.currentChapter = currentChapter
        self.initialState = State(selectedBookNumber: currentChapter.book)
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor

    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .selectBook(let num):
            return Observable.just(Mutaion.setCurrentBook(num))
            
        case .selectChapter(let num):
            UserDefaults.set(self.currentState.selectedBookNumber, forKey: .bookNumber)
            UserDefaults.set(num, forKey: .chapterNumber)
            self.listener?.select(chapter: BibleChapter(type: self.currentChapter.type,
                                                        book: self.currentState.selectedBookNumber,
                                                        chapter: num))
            return .empty()
            
        case .close:
            self.listener?.closeBibleSelect()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var newState = state
        switch mutation {
        case .setCurrentBook(let num):
            newState.selectedBookNumber = num
        }
        return newState
    }
}
