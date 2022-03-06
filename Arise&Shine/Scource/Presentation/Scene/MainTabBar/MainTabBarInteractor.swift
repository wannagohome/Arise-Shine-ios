//
//  MainTabBarInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs
import RxSwift

protocol MainTabBarRouting: ViewableRouting {}

protocol MainTabBarPresentable: Presentable {
    var listener: MainTabBarPresentableListener? { get set }
}

protocol MainTabBarListener: AnyObject {}

final class MainTabBarInteractor:
    PresentableInteractor<MainTabBarPresentable>,
    MainTabBarInteractable,
    MainTabBarPresentableListener {

    weak var router: MainTabBarRouting?
    weak var listener: MainTabBarListener?

    override init(presenter: MainTabBarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}
