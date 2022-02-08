//
//  ViewVIPBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol ViewVIPDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ViewVIPComponent: Component<ViewVIPDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ViewVIPBuildable: Buildable {
    func build(withListener listener: NewViewVIPListener) -> NewViewVIPRouting
}

final class NewVIPBuilder: Builder<ViewVIPDependency>, ViewVIPBuildable {

    override init(dependency: ViewVIPDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NewViewVIPListener) -> NewViewVIPRouting {
        let component = ViewVIPComponent(dependency: dependency)
        let viewController = NewVIPViewController()
        let interactor = NewViewVIPInteractor(presenter: viewController)
        interactor.listener = listener
        return ViewVIPRouter(interactor: interactor, viewController: viewController)
    }
}
