//
//  SelectBibleReadingRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs

protocol SelectBibleReadingInteractable: Interactable {
    var router: SelectBibleReadingRouting? { get set }
    var listener: SelectBibleReadingListener? { get set }
}

protocol SelectBibleReadingViewControllable: ViewControllable {}

final class SelectBibleReadingRouter:
    ViewableRouter<SelectBibleReadingInteractable, SelectBibleReadingViewControllable>,
    SelectBibleReadingRouting {
    
    override init(interactor: SelectBibleReadingInteractable,
                  viewController: SelectBibleReadingViewControllable) {
        
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}
