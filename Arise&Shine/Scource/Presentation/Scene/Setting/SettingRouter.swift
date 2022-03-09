//
//  SettingRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/14.
//

import RIBs

protocol SettingInteractable:
    Interactable,
    SelectPlanListener {
    var router: SettingRouting? { get set }
    var listener: SettingListener? { get set }
}

protocol SettingViewControllable: ViewControllable {
    func push(viewController: ViewControllable)
    func pop(viewController: ViewControllable)
}

final class SettingRouter: ViewableRouter<SettingInteractable, SettingViewControllable> {
    
    private let selectPlanBuilder: SelectPlanBuildable
    private var selectPlanRouter: SelectPlanRouting?
    
    init(interactor: SettingInteractable,
         viewController: SettingViewControllable,
         selectPlanBuilder: SelectPlanBuildable) {
        
        self.selectPlanBuilder = selectPlanBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}

extension SettingRouter: SettingRouting {
    func attatchSelectPlan() {
        let router = self.selectPlanBuilder.build(withListener: self.interactor)
        self.selectPlanRouter = router
        self.attachChild(router)
        self.viewController.push(viewController: router.viewControllable)
    }
    
    func detachSelectPlan() {
        if let router = self.selectPlanRouter {
            self.detachChild(router)
            self.viewController.pop(viewController: router.viewControllable)
            self.selectPlanRouter = nil
        }
    }
}
