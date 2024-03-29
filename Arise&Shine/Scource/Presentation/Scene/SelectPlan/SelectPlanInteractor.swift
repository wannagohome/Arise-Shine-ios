//
//  SelectPlanInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import Foundation
import RIBs
import RxSwift
import ReactorKit

import SQLite

protocol SelectPlanRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SelectPlanPresentable: Presentable {
    var listener: SelectPlanPresentableListener? { get set }
}

protocol SelectPlanListener: AnyObject {
    func popPlan()
}

struct SelectPlanPresentableState {
    var schedules: [Schedule]
    var toastMessage: String?
    var isShowingMessage: Bool = false
}


final class SelectPlanInteractor:
    PresentableInteractor<SelectPlanPresentable>,
    SelectPlanInteractable,
    SelectPlanPresentableListener,
    Reactor {
    
    // MARK: - Reactor
    
    typealias Action = SelectPlanPresentableAction
    typealias State = SelectPlanPresentableState
    
    var initialState: SelectPlanPresentableState
    
    enum Mutaion {
        case setToastMessage(String)
    }
    
    // MARK: - Properties
    
    weak var router: SelectPlanRouting?
    weak var listener: SelectPlanListener?
    
    // MARK: - Initialization
    
    init(presenter: SelectPlanPresentable,
         initialState: SelectPlanPresentableState) {
        
        self.initialState = initialState
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .selectSchedule(let selected):
            guard !(UserDefaults.string(forKey: .onGoing)?.hasPrefix("\(selected.id)") ?? false) else {
                return Observable.just(Mutaion.setToastMessage("성경 통독이 이미 진행중 입니다."))
            }
            
            let schedule = SchedulesManager()
            
            let startDate = selected.startDate ?? Date()
            let endDate = Calendar.current.date(byAdding: .day, value: selected.schedule.count - 1, to: selected.startDate ?? Date())!
            let range = Calendar.current.dateRange(startDate: startDate, endDate: endDate, component: .day, step: 1)
            for (i, d) in range.enumerated() {
                for scriptture in selected.schedule[i].components(separatedBy: ",") {
                    schedule.insert(
                        id: selected.id,
                        chapter: scriptture,
                        date: d
                    )
                }
            }
            
            
            UserDefaults.set(UserDefaults.string(forKey: .onGoing) ?? "" + "\(selected.id),", forKey: .onGoing)
            return Observable.just(Mutaion.setToastMessage("'\(selected.title)' 성경 통독을 시작합니다."))
            
        case .pop:
            self.listener?.popPlan()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var newState = state
        newState.isShowingMessage = false
        
        switch mutation {
        case .setToastMessage(let msg):
            newState.toastMessage = msg
            newState.isShowingMessage = true
        }
        
        return newState
    }
}

extension Calendar {
    func dateRange(startDate: Date, endDate: Date, component: Calendar.Component, step: Int) -> DateRange {
        let dateRange = DateRange(calendar: self, startDate: startDate, endDate: endDate, component: component, step: step, multiplier: 0)
        return dateRange
    }
}

struct DateRange : Sequence, IteratorProtocol {
    var calendar: Calendar
    var startDate: Date
    var endDate: Date
    var component: Calendar.Component
    var step: Int
    var multiplier: Int
        
    mutating func next() -> Date? {
        guard let nextDate = calendar.date(byAdding: component, value: step * multiplier, to: startDate)
        else {
            return nil
        }
        
        if nextDate > endDate {
            return nil
        } else {
            multiplier += 1
            return nextDate
        }
    }
}
