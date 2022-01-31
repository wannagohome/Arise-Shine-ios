//
//  SettingInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/14.
//

import Foundation
import RIBs
import ReactorKit
import RxSwift

protocol SettingRouting: ViewableRouting {
    func attatchSelectBibleReading()
    func detachSelectBibleReading()
}

protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
}

protocol SettingListener: class {}

struct SettingPresentableState {
    let tableItems: [String] = ["통독 계획", "내 메모", "라이센스", "앱 버전"]
}

final class SettingInteractor:
    PresentableInteractor<SettingPresentable>,
    SettingInteractable,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = SettingPresentableAction
    typealias State = SettingPresentableState
    
    enum Mutation {}
    
    // MARK: - Properties
    
    weak var router: SettingRouting?
    weak var listener: SettingListener?
    
    var initialState: SettingPresentableState
    
    // MARK: - Initialization
    
    init(presenter: SettingPresentable,
         initialState: SettingPresentableState) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

extension SettingInteractor: SettingPresentableListener {
    func pushSelectBibleReading() {
        self.router?.attatchSelectBibleReading()
    }
    
    func popBibleReading() {
        self.router?.detachSelectBibleReading()
    }
}
