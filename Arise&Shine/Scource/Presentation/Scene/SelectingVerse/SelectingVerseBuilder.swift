//
//  SelectingVerseBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs

protocol SelectingVerseDependency: Dependency {}

final class SelectingVerseComponent: Component<SelectingVerseDependency> {}

// MARK: - Builder

protocol SelectingVerseBuildable: Buildable {
    func build(withListener listener: SelectingVerseListener) -> SelectingVerseRouting
}

final class SelectingVerseBuilder: Builder<SelectingVerseDependency>, SelectingVerseBuildable {

    override init(dependency: SelectingVerseDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectingVerseListener) -> SelectingVerseRouting {
        let _ = SelectingVerseComponent(dependency: dependency)
        let viewController = SelectingVerseViewController()
        let interactor = SelectingVerseInteractor(presenter: viewController)
        interactor.listener = listener
        return SelectingVerseRouter(interactor: interactor,
                                    viewController: viewController)
    }
}
