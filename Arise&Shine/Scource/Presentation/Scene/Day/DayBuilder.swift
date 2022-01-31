//
//  DayBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/23.
//

import RxSwift
import Foundation
import RIBs

protocol DayDependency: Dependency {
    var currentDate: PublishSubject<Date> { get }
}

final class DayComponent: Component<DayDependency> {
    fileprivate var currentDate: PublishSubject<Date> {
        self.dependency.currentDate
    }
}

// MARK: - Builder

protocol DayBuildable: Buildable {
    func build(withListener listener: DayListener) -> DayRouting
}

final class DayBuilder:
    Builder<DayDependency>,
    DayBuildable {

    override init(dependency: DayDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DayListener) -> DayRouting {
        let component = DayComponent(dependency: dependency)
        let viewController = DayViewController.initWithStoryBoard()
        let interactor = DayInteractor(presenter: viewController,
                                       currentDate: component.currentDate)
        interactor.listener = listener
        return DayRouter(interactor: interactor, viewController: viewController)
    }
}
