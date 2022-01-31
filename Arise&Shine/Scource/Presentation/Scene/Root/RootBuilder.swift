//
//  RootBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs

protocol RootDependency: Dependency {}

final class RootComponent: Component<RootDependency>,MainTabBarDependency {}

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)
        
        let mainTabBarBuilder = MainTabBarBuilder(dependency: component)
        return RootRouter(interactor: interactor,
                          viewController: viewController,
                          mainTabBarBuilder: mainTabBarBuilder)
    }
}
