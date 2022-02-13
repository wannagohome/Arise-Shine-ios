//
//  NewPrayerRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol NewPrayerInteractable: Interactable {
    var router: NewPrayerRouting? { get set }
    var listener: NewPrayerListener? { get set }
}

protocol NewPrayerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NewPrayerRouter: ViewableRouter<NewPrayerInteractable, NewPrayerViewControllable>, NewPrayerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NewPrayerInteractable, viewController: NewPrayerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
