//
//  VIPDetailRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol VIPDetailInteractable:
    Interactable,
    NewPrayerListener {
    var router: VIPDetailRouting? { get set }
    var listener: VIPDetailListener? { get set }
}

protocol VIPDetailViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class VIPDetailRouter:
    ViewableRouter<VIPDetailInteractable, VIPDetailViewControllable>,
    VIPDetailRouting {
    
    private let newPrayerBuilder: NewPrayerBuildable
    private var newPrayerRouter: NewPrayerRouting?
    
    init(interactor: VIPDetailInteractable,
         viewController: VIPDetailViewControllable,
         newPrayerBuilder: NewPrayerBuildable) {
        
        self.newPrayerBuilder = newPrayerBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attatchNewPrayer(with vip: VIP,
                          prayer: Prayer?) {
        let router = self.newPrayerBuilder.build(withListener: self.interactor,
                                                 vip: vip,
                                                 prayer: prayer)
        self.newPrayerRouter = router
        self.attachChild(router)
        self.viewController.present(viewController: router.viewControllable)
    }
    
    func detatchNewPrayer() {
        if let router = self.newPrayerRouter {
            self.detachChild(router)
            self.viewController.dismiss(viewController: router.viewControllable)
            self.newPrayerRouter = nil
        }
    }
}
