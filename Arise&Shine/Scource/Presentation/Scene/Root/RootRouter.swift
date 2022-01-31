//
//  RootRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs

protocol RootInteractable: Interactable, MainTabBarListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
}

final class RootRouter:
    LaunchRouter<RootInteractable, RootViewControllable>,
    RootRouting {

    private var currentChild: ViewableRouting?
    private var mainTabBarBuilder: MainTabBarBuildable
    
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         mainTabBarBuilder: MainTabBarBuildable) {
        self.mainTabBarBuilder = mainTabBarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        self.attachMainTabBar()
    }
    
    func attachMainTabBar() {
        let router = mainTabBarBuilder.build(withListener: self.interactor)
        self.currentChild = router
        self.attachChild(router)
        self.viewController.present(viewController: router.viewControllable)
    }
}
