//
//  SettingBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/14.
//

import RIBs

protocol SettingDependency: Dependency {
    var settingViewController: SettingPresentable & SettingViewControllable { get }
}

final class SettingComponent:
    Component<SettingDependency>,
    SelectPlanDependency {
    
    fileprivate var initialState: SettingPresentableState { .init() }
    
    fileprivate var settingViewController: SettingPresentable & SettingViewControllable {
        dependency.settingViewController
    }
}

// MARK: - Builder

protocol SettingBuildable: Buildable {
    func build(withListener listener: SettingListener) -> SettingRouting
}

final class SettingBuilder:
    Builder<SettingDependency>,
    SettingBuildable {

    override init(dependency: SettingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingListener) -> SettingRouting {
        let component = SettingComponent(dependency: dependency)
        let interactor = SettingInteractor(presenter: component.settingViewController,
                                           initialState: component.initialState)
        interactor.listener = listener
        
        let selectPlanBuilder = SelectPlanBuilder(dependency: component)
        return SettingRouter(interactor: interactor,
                             viewController: component.settingViewController,
                             selectPlanBuilder: selectPlanBuilder)
    }
}
