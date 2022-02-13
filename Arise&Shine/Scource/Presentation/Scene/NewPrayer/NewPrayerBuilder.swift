//
//  NewPrayerBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol NewPrayerDependency: Dependency {}

final class NewPrayerComponent: Component<NewPrayerDependency> {}

// MARK: - Builder

protocol NewPrayerBuildable: Buildable {
    func build(withListener listener: NewPrayerListener,
               vip: VIP) -> NewPrayerRouting
}

final class NewPrayerBuilder:
    Builder<NewPrayerDependency>,
    NewPrayerBuildable {

    override init(dependency: NewPrayerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NewPrayerListener,
               vip: VIP) -> NewPrayerRouting {
        let component = NewPrayerComponent(dependency: dependency)
        let viewController = NewPrayerViewController.initWithStoryBoard()
        let interactor = NewPrayerInteractor(presenter: viewController,
                                             initialState: .init(currentVIP: vip))
        interactor.listener = listener
        return NewPrayerRouter(interactor: interactor, viewController: viewController)
    }
}
