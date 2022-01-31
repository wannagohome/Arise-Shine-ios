//
//  MonthBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs
import RxSwift
import UIKit

protocol MonthDependency: Dependency {
    var currentDate: PublishSubject<Date> { get }
}

final class MonthComponent: Component<MonthDependency> {
    fileprivate var currentDate: PublishSubject<Date> {
        self.dependency.currentDate
    }
}

// MARK: - Builder

protocol MonthBuildable: Buildable {
    func build(withListener listener: MonthListener) -> MonthRouting
}

final class MonthBuilder: Builder<MonthDependency>, MonthBuildable {

    override init(dependency: MonthDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MonthListener) -> MonthRouting {
        let component = MonthComponent(dependency: dependency)
        let viewController = MonthViewController.initWithStoryBoard()
        let interactor = MonthInteractor(presenter: viewController,
                                         currentDate: component.currentDate)
        interactor.listener = listener
        
        return MonthRouter(interactor: interactor, viewController: viewController)
    }
}
