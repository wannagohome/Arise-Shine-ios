//
//  BibleFontRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/26.
//

import RIBs

protocol BibleFontInteractable: Interactable {
    var router: BibleFontRouting? { get set }
    var listener: BibleFontListener? { get set }
}

protocol BibleFontViewControllable: ViewControllable {}

final class BibleFontRouter:
    ViewableRouter<BibleFontInteractable, BibleFontViewControllable>,
    BibleFontRouting {

    override init(interactor: BibleFontInteractable,
                  viewController: BibleFontViewControllable) {
        
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}
