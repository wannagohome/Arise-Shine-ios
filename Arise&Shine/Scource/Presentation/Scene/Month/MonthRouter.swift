//
//  MonthRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs

protocol MonthInteractable: Interactable {
    var router: MonthRouting? { get set }
    var listener: MonthListener? { get set }
}

protocol MonthViewControllable: ChildViewControllable {}

final class MonthRouter:
    ViewableRouter<MonthInteractable, MonthViewControllable>,
    MonthRouting {

    override init(interactor: MonthInteractable,
                  viewController: MonthViewControllable) {
        
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}
