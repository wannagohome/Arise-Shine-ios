//
//  PlanRouter.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs

protocol PlanInteractable: Interactable {
    var router: PlanRouting? { get set }
    var listener: PlanListener? { get set }
}

protocol PlanViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PlanRouter: ViewableRouter<PlanInteractable, PlanViewControllable>, PlanRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PlanInteractable, viewController: PlanViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
