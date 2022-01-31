//
//  CalendarRouter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs

protocol CalendarInteractable:
    Interactable,
    MonthListener,
    DayListener {
    
    var router: CalendarRouting? { get set }
    var listener: CalendarListener? { get set }
}

protocol CalendarViewControllable: ViewControllable {
    func addMonth(viewController: ViewControllable)
    func addDay(viewController: ViewControllable)
}

final class CalendarRouter:
    ViewableRouter<CalendarInteractable, CalendarViewControllable>,
    CalendarRouting {
    
    // MARK: - Properties
    
    private let monthBuilder: MonthBuildable
    private var monthRouter: MonthRouting?
    
    private let dayBuilder: DayBuildable
    private var dayRouter: DayRouting?
    
    // MARK: - Initialization
    
    init(interactor: CalendarInteractable,
         viewController: CalendarViewControllable,
         monthBuilder: MonthBuildable,
         dayBuilder: DayBuildable) {
        
        self.monthBuilder = monthBuilder
        self.dayBuilder = dayBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - Inheritance
    
    override func didLoad() {
        super.didLoad()
        self.attatchMonth()
        self.attatchDay()
    }
    
    // MARK: - Private methods
    
    private func attatchMonth() {
        let monthRouter = self.monthBuilder.build(withListener: self.interactor)
        self.monthRouter = monthRouter
        self.attachChild(monthRouter)
        self.viewController.addMonth(viewController: monthRouter.viewControllable)
    }
    
    private func attatchDay() {
        let dayRouter = self.dayBuilder.build(withListener: self.interactor)
        self.dayRouter = dayRouter
        self.attachChild(dayRouter)
        self.viewController.addDay(viewController: dayRouter.viewControllable)
    }
}
