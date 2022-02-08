//
//  PrayerInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/28.
//

import RIBs
import RxSwift
import ReactorKit
import RxDataSources

protocol PrayerRouting: ViewableRouting {
    func attachNewVIP()
    func detachNewVIP()
    
    func attachVIPDetail(with vip: VIP)
    func detachVIPDetail()
}

protocol PrayerPresentable: Presentable {
    var listener: PrayerPresentableListener? { get set }
}

protocol PrayerListener: class {}

struct PrayerPresentableState {
    var vips: [VIP] = [VIP(id: -1, name: "dummy", description: "dummy")]
    var sections: [VIPSection] {
        [ VIPSection(header: "내 VIP", items: self.vips) ]
    }
}

final class PrayerInteractor:
    PresentableInteractor<PrayerPresentable>,
    PrayerPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = PrayerPresentableAction
    typealias State = PrayerPresentableState
    
    enum Mutation {
        case setVIPs([VIP])
    }
    
    var initialState: State
    
    // MARK: - Properties

    weak var router: PrayerRouting?
    weak var listener: PrayerListener?
    private let db = VIPManager()
    
    // MARK: - Initialization
    
    init(presenter: PrayerPresentable,
         initialState: State) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.just(Mutation.setVIPs(db.selectAll()))
        
        case .tapNewVIP:
            self.router?.attachNewVIP()
            return .empty()
            
        case .add(let name):
            let vip = VIP(name: name, description: "구현 예정")
            
            db.insert(vip: vip)
            return Observable.just(Mutation.setVIPs(db.selectAll()))
            
        case .selectTable(let vip):
            self.router?.attachVIPDetail(with: vip)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newSate = state

        switch mutation {
        case .setVIPs(let vips):
            newSate.vips = vips
        }
        
        return newSate
    }
}

extension PrayerInteractor: PrayerInteractable {
    func addNewVIP(of name: String) {
        self.action.onNext(.add(name))
    }
    
    func closeBibleNewVIP() {
        self.router?.detachNewVIP()
    }
}
