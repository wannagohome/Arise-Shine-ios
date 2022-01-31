//
//  SettingRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/14.
//

import RIBs

protocol SettingInteractable:
    Interactable,
    SelectBibleReadingListener {
    var router: SettingRouting? { get set }
    var listener: SettingListener? { get set }
}

protocol SettingViewControllable: ViewControllable {
    func push(viewController: ViewControllable)
    func pop(viewController: ViewControllable)
}

final class SettingRouter: ViewableRouter<SettingInteractable, SettingViewControllable> {
    
    private let selectBibleReadingBuilder: SelectBibleReadingBuildable
    private var selectBibleReadingRouter: SelectBibleReadingRouting?
    
    init(interactor: SettingInteractable,
         viewController: SettingViewControllable,
         selectBibleReadingBuilder: SelectBibleReadingBuildable) {
        
        self.selectBibleReadingBuilder = selectBibleReadingBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
}

extension SettingRouter: SettingRouting {
    func attatchSelectBibleReading() {
        let router = self.selectBibleReadingBuilder.build(withListener: self.interactor)
        self.selectBibleReadingRouter = router
        self.attachChild(router)
        self.viewController.push(viewController: router.viewControllable)
    }
    
    func detachSelectBibleReading() {
        if let router = self.selectBibleReadingRouter {
            self.detachChild(router)
            self.viewController.pop(viewController: router.viewControllable)
            self.selectBibleReadingRouter = nil
        }
    }
}
