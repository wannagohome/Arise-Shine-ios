//
//  BibleReadingRouter.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs

protocol BibleReadingInteractable: Interactable {
    var router: BibleReadingRouting? { get set }
    var listener: BibleReadingListener? { get set }
}

protocol BibleReadingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BibleReadingRouter: ViewableRouter<BibleReadingInteractable, BibleReadingViewControllable>, BibleReadingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BibleReadingInteractable, viewController: BibleReadingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
