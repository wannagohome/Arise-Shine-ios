//
//  MonthViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs
import RxSwift
import FSCalendar
import UIKit

protocol MonthPresentableListener: class {
    func didSelect(date: Date)
}

final class MonthViewController:
    BaseViewController,
    MonthPresentable,
    MonthViewControllable {
     
    // MARK: - Properties
    
    weak var listener: MonthPresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var calendarView: FSCalendar!
    

    // MARK: - Inheritance
    
    override func attribute() {
        calendarView.delegate = self
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.weekdayTextColor = .black
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        calendarView.appearance.headerTitleColor = .black
    }
}


extension MonthViewController {
    static func initWithStoryBoard() -> MonthViewController {
        MonthViewController.withStoryboard(storyboard: .month)
    }
}


extension MonthViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.listener?.didSelect(date: date)
    }
}
