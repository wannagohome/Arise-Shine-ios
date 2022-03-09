//
//  PlanRouter.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs

protocol PlanInteractable:
    Interactable,
    PlanDetailListener {
    var router: PlanRouting? { get set }
    var listener: PlanListener? { get set }
}

protocol PlanViewControllable: ViewControllable {
    func push(viewConroller: ViewControllable)
    func pop(viewController: ViewControllable)
}

final class PlanRouter:
    ViewableRouter<PlanInteractable, PlanViewControllable>,
    PlanRouting {

    private let planDetailBuilder: PlanDetailBuildable
    private var planDetailRouter: PlanDetailRouting?
    
    init(
        interactor: PlanInteractable,
        viewController: PlanViewControllable,
        planDetailBuilder: PlanDetailBuildable
    ) {
        self.planDetailBuilder = planDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attatchPlanDetail() {
        let router = self.planDetailBuilder.build(withListener: self.interactor)
        self.planDetailRouter = router
        self.attachChild(router)
        self.viewController.push(viewConroller: router.viewControllable)
    }
    
    func detachPlanDeatil() {
        if let router = self.planDetailRouter {
            self.detachChild(router)
            self.viewController.pop(viewController: router.viewControllable)
            self.planDetailRouter = nil
        }
    }
}
