//
//  BibleRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs
import PanModal

protocol BibleInteractable:
    Interactable,
    SelectListener,
    BibleFontListener,
    SelectingVerseListener {
    
    var router: BibleRouting? { get set }
    var listener: BibleListener? { get set }
}

protocol BibleViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    
    func addSelecting(viewController: ViewControllable)
    func removeSelecting(viewController: ViewControllable)
}

final class BibleRouter:
    ViewableRouter<BibleInteractable, BibleViewControllable>,
    BibleRouting {
    
    // MARK: - Properties
    
    private let selectBuilder: SelectBuildable
    private var selectRouter: SelectRouting?
    
    private let bibleFontBuilder: BibleFontBuildable
    private var bibleFontRouter: BibleFontRouting?
    
    private let selectingVerseBuilder: SelectingVerseBuildable
    private var selectingVerseRouter: SelectingVerseRouting?
    
    // MARK: - Initialization
    
    init(interactor: BibleInteractable,
         viewController: BibleViewControllable,
         selectBuilder: SelectBuildable,
         bibleFontBuilder: BibleFontBuildable,
         selectingVerseBuilder: SelectingVerseBuildable) {
        
        self.selectBuilder = selectBuilder
        self.bibleFontBuilder = bibleFontBuilder
        self.selectingVerseBuilder = selectingVerseBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
    
    func attachSelect() {
        let router = self.selectBuilder.build(withListener: self.interactor)
        self.selectRouter = router
        self.attachChild(router)
        self.viewController.present(viewController: router.viewControllable)
    }
    
    func detachSelect() {
        if let router = self.selectRouter {
            self.detachChild(router)
            self.viewController.dismiss(viewController: router.viewControllable)
            self.selectRouter = nil
        }
    }
    
    func attachBibleFont() {
        let router = self.bibleFontBuilder.build(withListener: self.interactor)
        self.bibleFontRouter = router
        self.attachChild(router)
        self.viewController.present(viewController: router.viewControllable)
    }
    
    func detachBibleFont() {
        if let router = self.bibleFontRouter {
            self.detachChild(router)
            self.viewController.dismiss(viewController: router.viewControllable)
            self.bibleFontRouter = nil
        }
    }
    
    func attachSelectingVerse() {
        guard self.selectingVerseRouter == nil else { return }
        let router = self.selectingVerseBuilder.build(withListener: self.interactor)
        self.selectingVerseRouter = router
        self.attachChild(router)
        self.viewController.addSelecting(viewController: router.viewControllable)
    }
    
    func detachSelectingVerse() {
        if let router = self.selectingVerseRouter {
            self.detachChild(router)
            self.viewController.removeSelecting(viewController: router.viewControllable)
            self.selectingVerseRouter = nil
        }
    }
}
