//
//  MainTabBarBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs
import UIKit

protocol MainTabBarDependency: Dependency {
    
}

final class MainTabBarComponent:
    Component<MainTabBarDependency>,
    BibleDependency,
    PlanDependency,
    PrayerDependency,
    SettingDependency {
    
    var bibleViewController: BiblePresentable & BibleViewControllable
    var planViewController: PlanPresentable & PlanViewControllable
    var prayerViewController: PrayerPresentable & PrayerViewControllable
    var settingViewController: SettingPresentable & SettingViewControllable
    
    override init(dependency: MainTabBarDependency) {
        self.bibleViewController = BibleViewController.initWithStoryBoard()
        self.planViewController = PlanViewController()
        self.prayerViewController = PrayerViewController()
        self.settingViewController = SettingViewController.initWithStoryBoard()
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainTabBarBuildable: Buildable {
    func build(withListener listener: MainTabBarListener) -> MainTabBarRouting
}

final class MainTabBarBuilder:
    Builder<MainTabBarDependency>,
    MainTabBarBuildable {

    override init(dependency: MainTabBarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainTabBarListener) -> MainTabBarRouting {
        let component = MainTabBarComponent(dependency: dependency)
        
        let viewControllers = [
            component.bibleViewController,
            component.planViewController,
            component.prayerViewController,
            component.settingViewController
        ].map { UINavigationController(root: $0) }
        
        
        let viewController = MainTabBarViewController(viewControllers: viewControllers)
        let interactor = MainTabBarInteractor(presenter: viewController)
        interactor.listener = listener
        
        let bibleBuilder = BibleBuilder(dependency: component)
        let planBuilder = PlanBuilder(dependency: component)
        let prayerBuiler = PrayerBuilder(dependency: component)
        let settingBuilder = SettingBuilder(dependency: component)
        
        return MainTabBarRouter(interactor: interactor,
                                viewController: viewController,
                                bibleBuilder: bibleBuilder,
                                planBuilder: planBuilder,
                                prayerBuilder: prayerBuiler,
                                settingBuilder: settingBuilder)
    }
}
