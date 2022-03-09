//
//  PlanDetailBuilder.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import RIBs

protocol PlanDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PlanDetailComponent: Component<PlanDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PlanDetailBuildable: Buildable {
    func build(withListener listener: PlanDetailListener) -> PlanDetailRouting
}

final class PlanDetailBuilder: Builder<PlanDetailDependency>, PlanDetailBuildable {

    override init(dependency: PlanDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PlanDetailListener) -> PlanDetailRouting {
        let component = PlanDetailComponent(dependency: dependency)
        let viewController = PlanDetailViewController()
        let interactor = PlanDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return PlanDetailRouter(interactor: interactor, viewController: viewController)
    }
}
