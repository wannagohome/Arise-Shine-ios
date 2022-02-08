//
//  PrayerRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/28.
//

import RIBs

protocol PrayerInteractable:
    Interactable,
    NewVIPListener,
    VIPDetailListener {
    
    var router: PrayerRouting? { get set }
    var listener: PrayerListener? { get set }
}

protocol PrayerViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class PrayerRouter:
    ViewableRouter<PrayerInteractable, PrayerViewControllable>,
    PrayerRouting {

    private let newVIPBuilder: NewVIPBuildable
    private var newVIPRouter: NewVIPRouting?
    
    private let vipDetailBuilder: VIPDetailBuildable
    private var vipDeatilRouter: VIPDetailRouting?
    
    init(interactor: PrayerInteractable,
         viewController: PrayerViewControllable,
         newVIPBuilder: NewVIPBuildable,
         vipDetailBuilder: VIPDetailBuildable) {
        
        self.newVIPBuilder = newVIPBuilder
        self.vipDetailBuilder = vipDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachNewVIP() {
        let router = self.newVIPBuilder.build(withListener: self.interactor)
        self.newVIPRouter = router
        self.attachChild(router)
        self.viewController.present(viewController: router.viewControllable)
    }
    
    func detachNewVIP() {
        if let router = self.newVIPRouter {
            self.detachChild(router)
            self.viewController.dismiss(viewController: router.viewControllable)
            self.newVIPRouter = nil
        }
    }
    
    func attachVIPDetail(with vip: VIP) {
        let router = self.vipDetailBuilder.build(withListener: self.interactor,
                                                 vip: vip)
        self.vipDeatilRouter = router
        self.attachChild(router)
        self.viewController.present(viewController: router.viewControllable)
    }
    
    func detachVIPDetail() {
        if let router = self.vipDeatilRouter {
            self.detachChild(router)
            self.viewController.dismiss(viewController: router.viewControllable)
            self.newVIPRouter = nil
        }
    }
}
