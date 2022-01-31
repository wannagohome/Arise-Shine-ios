//
//  DayRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/23.
//

import RIBs

protocol DayInteractable: Interactable {
    var router: DayRouting? { get set }
    var listener: DayListener? { get set }
}

protocol DayViewControllable: ChildViewControllable {}

final class DayRouter:
    ViewableRouter<DayInteractable, DayViewControllable>,
    DayRouting {

    override init(interactor: DayInteractable,
                  viewController: DayViewControllable) {
        
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}
