//
//  PlanDetailRouter.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/07/09.
//

import RIBs

protocol PlanDetailInteractable: Interactable {
    var router: PlanDetailRouting? { get set }
    var listener: PlanDetailListener? { get set }
}

protocol PlanDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PlanDetailRouter: ViewableRouter<PlanDetailInteractable, PlanDetailViewControllable>, PlanDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PlanDetailInteractable, viewController: PlanDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
