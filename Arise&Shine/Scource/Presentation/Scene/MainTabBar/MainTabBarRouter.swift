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
    CalendarListener,
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
    
    private let calendarBuilder: CalendarBuildable
    private var calendarRouter: CalendarRouting?
    
    private let settingBuilder: SettingBuildable
    private var settingRouter: SettingRouting?
    
    // MARK: - Initialization
    
    init(interactor: MainTabBarInteractable,
         viewController: MainTabBarViewControllable,
         bibleBuilder: BibleBuildable,
         calendarBuilder: CalendarBuildable,
         settingBuilder: SettingBuildable) {
        
        self.bibleBuilder = bibleBuilder
        self.calendarBuilder = calendarBuilder
        self.settingBuilder = settingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - Inheritance
    
    override func didLoad() {
        super.didLoad()
        self.attatchBible()
        self.attatchCalendar()
        self.attatchSetting()
    }
    
    // MARK: - Private methods
    
    private func attatchBible() {
        let bibleRouter = self.bibleBuilder.build(withListener: self.interactor)
        self.bibleRouter = bibleRouter
        self.attachChild(bibleRouter)
    }
    
    private func attatchCalendar() {
        let calendarRouter = self.calendarBuilder.build(withListener: self.interactor)
        self.calendarRouter = calendarRouter
        self.attachChild(calendarRouter)
    }
    
    private func attatchSetting() {
        let settingRouter = self.settingBuilder.build(withListener: self.interactor)
        self.settingRouter = settingRouter
        self.attachChild(settingRouter)
    }
}
