//
//  CalendarBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs
import RxSwift
import UIKit

protocol CalendarDependency: Dependency {
    var calendarViewController: CalendarPresentable & CalendarViewControllable { get }
}

final class CalendarComponent:
    Component<CalendarDependency>,
    MonthDependency,
    DayDependency {
    
    var currentDate: PublishSubject<Date> = PublishSubject()
    fileprivate var calendarViewController: CalendarPresentable & CalendarViewControllable {
        dependency.calendarViewController
    }
}

// MARK: - Builder

protocol CalendarBuildable: Buildable {
    func build(withListener listener: CalendarListener) -> CalendarRouting
}

final class CalendarBuilder: Builder<CalendarDependency>, CalendarBuildable {

    override init(dependency: CalendarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CalendarListener) -> CalendarRouting {
        let component = CalendarComponent(dependency: dependency)
        let viewController = component.calendarViewController
        let interactor = CalendarInteractor(presenter: viewController)
        interactor.listener = listener
        
        let monthBuilder = MonthBuilder(dependency: component)
        let dayBuilder = DayBuilder(dependency: component)
        return CalendarRouter(interactor: interactor,
                              viewController: viewController,
                              monthBuilder: monthBuilder,
                              dayBuilder: dayBuilder)
    }
}
