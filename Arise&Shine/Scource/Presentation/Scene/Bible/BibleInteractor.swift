//
//  BibleInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//
import Foundation
import RIBs
import ReactorKit
import RxSwift
import SQLite

protocol BibleRouting: ViewableRouting {
    func attachSelect()
    func detachSelect()
    func attachBibleFont()
    func detachBibleFont()
    func attachSelectingVerse()
    func detachSelectingVerse()
}

protocol BiblePresentable: Presentable {
    var listener: BiblePresentableListener? { get set }
}

protocol BibleListener: class {}

final class BibleInteractor:
    PresentableInteractor<BiblePresentable>,
    BiblePresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = BiblePresentableAction
    typealias State = BiblePresentableState
    
    enum Mutaion {
        case setCurrentChapter(BibleChapter)
        case setIsSelect(Int)
        case resetSelecting
        case appendFontSize(Int)
    }
    
    var initialState: State
    
    // MARK: - Properties
    
    weak var router: BibleRouting?
    weak var listener: BibleListener?
    
    // MARK: - Initialization
    
    init(presenter: BiblePresentable,
         initialState: BiblePresentableState) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .turnChapter(let chapter):
            return Observable.just(Mutaion.setCurrentChapter(chapter))
            
        case .tapTitle:
            self.router?.attachSelect()
            return .empty()
            
        case .tapFont:
            self.router?.attachBibleFont()
            return .empty()
            
        case .selectVerse(let row):
            return Observable.just(Mutaion.setIsSelect(row))
            
        case .resetSelecting:
            return Observable.just(Mutaion.resetSelecting)
            
        case .fonSizeUp:
            return Observable.just(Mutaion.appendFontSize(1))
            
        case .fonSizeDown:
            return Observable.just(Mutaion.appendFontSize(-1))
        }
    }
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var newState = state
        switch mutation {
        case .setCurrentChapter(let chapter):
            newState.currentChapter = chapter
            
        case .setIsSelect(let row):
            newState.verses[row].isSelected = !newState.verses[row].isSelected
            newState.isSelecting = !newState.verses.filter { $0.isSelected }.isEmpty
            
        case .resetSelecting:
            for i in newState.verses.indices {
                newState.verses[i].isSelected = false
            }
            newState.isSelecting = false
            
        case .appendFontSize(let num):
            for i in newState.verses.indices {
                newState.verses[i].fontSize += num
            }
        }
        
        if newState.isSelecting {
            self.router?.attachSelectingVerse()
        } else {
            self.router?.detachSelectingVerse()
        }
        
        return newState
    }
}

extension BibleInteractor: BibleInteractable {
    
    func select(chapter: BibleChapter) {
        self.router?.detachSelect()
        self.action.onNext(.turnChapter(chapter))
    }
    
    func closeBibleSelect() {
        self.router?.detachSelect()
    }
    
    func cancleSelecting() {
        self.router?.detachSelectingVerse()
        self.action.onNext(.resetSelecting)
    }
    
    func closeBibleFont() {
        self.router?.detachBibleFont()
    }
    
    func sizeUp() {
        self.action.onNext(.fonSizeUp)
    }
    
    func sizeDown() {
        self.action.onNext(.fonSizeDown)
    }
}
