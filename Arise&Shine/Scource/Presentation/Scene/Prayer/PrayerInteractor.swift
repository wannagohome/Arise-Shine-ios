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

protocol PrayerListener: AnyObject {}

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
    var initialState: State
    enum Mutation {
        case setVIPs([VIP])
    }
    
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
            
        case .add(let name, let desc):
            let vip = VIP(name: name, description: desc)
            
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
    func addNewVIP(of name: String,
                   description: String) {
        self.action.onNext(.add(name, description))
    }
    
    func closeBibleNewVIP() {
        self.router?.detachNewVIP()
    }
    
    func closeVIPDetail() {
        self.router?.detachVIPDetail()
    }
}
