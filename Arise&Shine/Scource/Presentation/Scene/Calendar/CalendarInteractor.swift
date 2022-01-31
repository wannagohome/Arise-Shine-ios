//
//  CalendarInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import Foundation

import RIBs
import RxSwift

protocol CalendarRouting: ViewableRouting {}

protocol CalendarPresentable: Presentable {
    var listener: CalendarPresentableListener? { get set }
}

protocol CalendarListener: class {}

final class CalendarInteractor:
    PresentableInteractor<CalendarPresentable>,
    CalendarInteractable,
    CalendarPresentableListener {

    weak var router: CalendarRouting?
    weak var listener: CalendarListener?

    override init(presenter: CalendarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}
