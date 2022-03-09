//
//  PlanBuilder.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs

protocol PlanDependency: Dependency {
    var planViewController: PlanPresentable & PlanViewControllable { get }
}

final class PlanComponent: Component<PlanDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PlanBuildable: Buildable {
    func build(withListener listener: PlanListener) -> PlanRouting
}

final class PlanBuilder: Builder<PlanDependency>, PlanBuildable {

    override init(dependency: PlanDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PlanListener) -> PlanRouting {
        let component = PlanComponent(dependency: dependency)
        let viewController = component.dependency.planViewController
        let interactor = PlanInteractor(presenter: viewController)
        interactor.listener = listener
        return PlanRouter(interactor: interactor, viewController: viewController)
    }
}
