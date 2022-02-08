//
//  VIPDetailRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol VIPDetailInteractable: Interactable {
    var router: VIPDetailRouting? { get set }
    var listener: VIPDetailListener? { get set }
}

protocol VIPDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class VIPDetailRouter: ViewableRouter<VIPDetailInteractable, VIPDetailViewControllable>, VIPDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: VIPDetailInteractable, viewController: VIPDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
