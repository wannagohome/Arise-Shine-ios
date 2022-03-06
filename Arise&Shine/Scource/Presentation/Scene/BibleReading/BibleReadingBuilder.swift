//
//  BibleReadingBuilder.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs

protocol BibleReadingDependency: Dependency {
    var bibleReadingViewController: BibleReadingPresentable & BibleReadingViewControllable { get }
}

final class BibleReadingComponent: Component<BibleReadingDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BibleReadingBuildable: Buildable {
    func build(withListener listener: BibleReadingListener) -> BibleReadingRouting
}

final class BibleReadingBuilder: Builder<BibleReadingDependency>, BibleReadingBuildable {

    override init(dependency: BibleReadingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BibleReadingListener) -> BibleReadingRouting {
        let component = BibleReadingComponent(dependency: dependency)
        let viewController = component.dependency.bibleReadingViewController
        let interactor = BibleReadingInteractor(presenter: viewController)
        interactor.listener = listener
        return BibleReadingRouter(interactor: interactor, viewController: viewController)
    }
}
