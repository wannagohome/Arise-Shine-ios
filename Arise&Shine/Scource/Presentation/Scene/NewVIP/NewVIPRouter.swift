//
//  ViewVIPRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol NewVIPInteractable: Interactable {
    var router: NewVIPRouting? { get set }
    var listener: NewVIPListener? { get set }
}

protocol NewVIPViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NewVIPRouter: ViewableRouter<NewVIPInteractable, NewVIPViewControllable>, NewVIPRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NewVIPInteractable, viewController: NewVIPViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
