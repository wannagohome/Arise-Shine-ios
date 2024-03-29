//
//  MainTabBarRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs

protocol MainTabBarInteractable:
    Interactable,
    BibleListener,
    PlanListener,
    PrayerListener,
    SettingListener {
    
    var router: MainTabBarRouting? { get set }
    var listener: MainTabBarListener? { get set }
}

protocol MainTabBarViewControllable: ViewControllable {}

final class MainTabBarRouter:
    ViewableRouter<MainTabBarInteractable, MainTabBarViewControllable>,
    MainTabBarRouting {
    
    // MARK: - Properties
    
    private let bibleBuilder: BibleBuildable
    private var bibleRouter: BibleRouting?
    
    private let planBuilder: PlanBuildable
    private var planRouter: PlanRouting?
    
    private let prayerBuilder: PrayerBuildable
    private var prayerRouter: PrayerRouting?
    
    private let settingBuilder: SettingBuildable
    private var settingRouter: SettingRouting?
    
    // MARK: - Initialization
    
    init(interactor: MainTabBarInteractable,
         viewController: MainTabBarViewControllable,
         bibleBuilder: BibleBuildable,
         planBuilder: PlanBuildable,
         prayerBuilder: PrayerBuildable,
         settingBuilder: SettingBuildable) {
        
        self.bibleBuilder = bibleBuilder
        self.planBuilder = planBuilder
        self.prayerBuilder = prayerBuilder
        self.settingBuilder = settingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - Inheritance
    
    override func didLoad() {
        super.didLoad()
        self.attatchBible()
        self.attatchCalendar()
        self.attatchPrayer()
        self.attatchSetting()
    }
    
    // MARK: - Private methods
    
    private func attatchBible() {
        let bibleRouter = self.bibleBuilder.build(withListener: self.interactor)
        self.bibleRouter = bibleRouter
        self.attachChild(bibleRouter)
    }
    
    private func attatchCalendar() {
        let planRouter = self.planBuilder.build(withListener: self.interactor)
        self.planRouter = planRouter
        self.attachChild(planRouter)
    }
    
    private func attatchPrayer() {
        let prayerRouter = self.prayerBuilder.build(withListener: self.interactor)
        self.prayerRouter = prayerRouter
        self.attachChild(prayerRouter)
    }
    
    private func attatchSetting() {
        let settingRouter = self.settingBuilder.build(withListener: self.interactor)
        self.settingRouter = settingRouter
        self.attachChild(settingRouter)
    }
}
