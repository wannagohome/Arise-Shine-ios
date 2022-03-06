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
    BibleReadingListener,
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
    
    private let bibleReadingBuilder: BibleReadingBuildable
    private var bibleReadingRouter: BibleReadingRouting?
    
    private let prayerBuilder: PrayerBuildable
    private var prayerRouter: PrayerRouting?
    
    private let settingBuilder: SettingBuildable
    private var settingRouter: SettingRouting?
    
    // MARK: - Initialization
    
    init(interactor: MainTabBarInteractable,
         viewController: MainTabBarViewControllable,
         bibleBuilder: BibleBuildable,
         bibleReadingBuilder: BibleReadingBuildable,
         prayerBuilder: PrayerBuildable,
         settingBuilder: SettingBuildable) {
        
        self.bibleBuilder = bibleBuilder
        self.bibleReadingBuilder = bibleReadingBuilder
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
        let bibleReadingRouter = self.bibleReadingBuilder.build(withListener: self.interactor)
        self.bibleReadingRouter = bibleReadingRouter
        self.attachChild(bibleReadingRouter)
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
