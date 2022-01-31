//
//  DayInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/23.
//

import RIBs
import Foundation
import RxSwift
import SQLite

protocol DayRouting: ViewableRouting {}

protocol DayPresentable: Presentable {
    var listener: DayPresentableListener? { get set }
}

protocol DayListener: class {}

final class DayInteractor:
    PresentableInteractor<DayPresentable>,
    DayInteractable,
    DayPresentableListener {

    weak var router: DayRouting?
    weak var listener: DayListener?

    let todayChapters: Observable<[String]>
    
    init(presenter: DayPresentable,
         currentDate: PublishSubject<Date>) {
        
        let bible = BibleManager(of: .kor)
        self.todayChapters = currentDate
            .map { date -> [String] in
                SchedulesManager().select(of: date)
                    .map {
                        guard let bookNumber = Int($0.components(separatedBy: ":").first!),
                              let chapters = $0.components(separatedBy: ":").last else {
                            return nil
                        }
                        return "\(bible.getBookName(of: bookNumber)!) " + chapters + "장"
                    }.compactMap { $0 }
                    
            }
        
        super.init(presenter: presenter)
        presenter.listener = self
        
    }
}
