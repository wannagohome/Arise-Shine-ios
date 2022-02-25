//
//  NewPrayerInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import Foundation
import RIBs
import RxSwift
import ReactorKit

protocol NewPrayerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NewPrayerPresentable: Presentable {
    var listener: NewPrayerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol NewPrayerListener: class {
    func closeNewPrayer()
    func addNew(prayer: Prayer)
    func edit(prayer: Prayer)
}

struct NewPrayerPresentableState {
    let currentVIP: VIP
    var prayer: Prayer?
}

final class NewPrayerInteractor:
    PresentableInteractor<NewPrayerPresentable>,
    NewPrayerInteractable,
    NewPrayerPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = NewPrayerPresentableAction
    typealias State = NewPrayerPresentableState
    
    var initialState: State
    
    // MARK: - Properties
    
    weak var router: NewPrayerRouting?
    weak var listener: NewPrayerListener?
    
    // MARK: - Initialization
    
    init(presenter: NewPrayerPresentable,
         initialState: State) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .close:
            self.listener?.closeNewPrayer()
            return .empty()
            
        case .done(let contents):
            var prayer: Prayer
            
            if self.currentState.prayer == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                prayer = Prayer(
                    createdAt: dateFormatter.string(from: Date()),
                    contents: contents,
                    vipID: self.currentState.currentVIP.id
                )
                PrayerManager().insert(prayer: prayer)
                self.listener?.addNew(prayer: prayer)
            } else {
                prayer = self.currentState.prayer!
                prayer.contents = contents
                PrayerManager().updateContents(of: prayer)
                self.listener?.edit(prayer: prayer)
            }
            
            
            self.listener?.closeNewPrayer()
            return .empty()
        }
    }
}
