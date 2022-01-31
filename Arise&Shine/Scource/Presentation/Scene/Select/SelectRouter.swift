//
//  SelectRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs

protocol SelectInteractable: Interactable {
    var router: SelectRouting? { get set }
    var listener: SelectListener? { get set }
}

protocol SelectViewControllable: ViewControllable {}

final class SelectRouter:
    ViewableRouter<SelectInteractable, SelectViewControllable>,
    SelectRouting {

    override init(interactor: SelectInteractable,
                  viewController: SelectViewControllable) {
        
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}
