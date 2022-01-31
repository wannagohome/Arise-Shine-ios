//
//  SelectingVerseRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs

protocol SelectingVerseInteractable: Interactable {
    var router: SelectingVerseRouting? { get set }
    var listener: SelectingVerseListener? { get set }
}

protocol SelectingVerseViewControllable: ViewControllable {}

final class SelectingVerseRouter:
    ViewableRouter<SelectingVerseInteractable, SelectingVerseViewControllable>,
    SelectingVerseRouting {
    
    override init(interactor: SelectingVerseInteractable,
                  viewController: SelectingVerseViewControllable) {
        
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}
