//
//  BibleFontBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/26.
//

import RIBs

protocol BibleFontDependency: Dependency {}

final class BibleFontComponent: Component<BibleFontDependency> {}

// MARK: - Builder

protocol BibleFontBuildable: Buildable {
    func build(withListener listener: BibleFontListener) -> BibleFontRouting
}

final class BibleFontBuilder: Builder<BibleFontDependency>, BibleFontBuildable {

    override init(dependency: BibleFontDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BibleFontListener) -> BibleFontRouting {
        let _ = BibleFontComponent(dependency: dependency)
        let viewController = BibleFontViewController.initWithStoryBoard()
        let interactor = BibleFontInteractor(presenter: viewController,
                                             initialState: .init())
        interactor.listener = listener
        return BibleFontRouter(interactor: interactor, viewController: viewController)
    }
}
