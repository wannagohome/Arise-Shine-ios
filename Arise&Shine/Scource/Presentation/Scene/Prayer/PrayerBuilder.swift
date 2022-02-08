//
//  PrayerBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/28.
//

import RIBs

protocol PrayerDependency: Dependency {
    var prayerViewController: PrayerPresentable & PrayerViewControllable { get }
}

final class PrayerComponent:
    Component<PrayerDependency>,
    NewVIPDependency,
    VIPDetailDependency {
    
    fileprivate var prayerViewController: PrayerPresentable & PrayerViewControllable {
        dependency.prayerViewController
    }
}

// MARK: - Builder

protocol PrayerBuildable: Buildable {
    func build(withListener listener: PrayerListener) -> PrayerRouting
}

final class PrayerBuilder: Builder<PrayerDependency>, PrayerBuildable {

    override init(dependency: PrayerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PrayerListener) -> PrayerRouting {
        let components = PrayerComponent(dependency: dependency)
        let interactor = PrayerInteractor(presenter: components.prayerViewController,
                                          initialState: .init())
        interactor.listener = listener
        
        let newVIPBuilder = NewVIPBuilder(dependency: components)
        let vipDetailBuilder = VIPDetailBuilder(dependency: components)
        return PrayerRouter(interactor: interactor,
                            viewController: components.prayerViewController,
                            newVIPBuilder: newVIPBuilder,
                            vipDetailBuilder: vipDetailBuilder)
    }
}
