//
//  MonthInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import Foundation

import RIBs
import RxSwift

protocol MonthRouting: ViewableRouting {}

protocol MonthPresentable: Presentable {
    var listener: MonthPresentableListener? { get set }
}

protocol MonthListener: class {}

final class MonthInteractor:
    PresentableInteractor<MonthPresentable>,
    MonthInteractable,
    MonthPresentableListener {

    weak var router: MonthRouting?
    weak var listener: MonthListener?
    
    private let currentDate: PublishSubject<Date>

    init(presenter: MonthPresentable,
         currentDate: PublishSubject<Date>) {
        
        self.currentDate = currentDate
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

extension MonthInteractor {
    func didSelect(date: Date) {
        self.currentDate.onNext(date)
    }
}
