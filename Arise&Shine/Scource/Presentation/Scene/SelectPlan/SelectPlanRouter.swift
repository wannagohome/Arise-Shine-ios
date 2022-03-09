//
//  SelectPlanRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs

protocol SelectPlanInteractable: Interactable {
    var router: SelectPlanRouting? { get set }
    var listener: SelectPlanListener? { get set }
}

protocol SelectPlanViewControllable: ViewControllable {}

final class SelectPlanRouter:
    ViewableRouter<SelectPlanInteractable, SelectPlanViewControllable>,
    SelectPlanRouting {
    
    override init(interactor: SelectPlanInteractable,
                  viewController: SelectPlanViewControllable) {
        
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}
