//
//  SchedulesManager.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/25.
//

import Foundation
import SQLite

struct SchedulesManager {
    
    private let db: Connection!
    private let schedules = Table("schedules")
    private let id = Expression<Int>("id")
    private let chapter = Expression<String>("chapter")
    private let date = Expression<String>("date")
    private let isOnDay = Expression<Bool>("isOnDay")
    private let isLate = Expression<Bool>("isLate")
    private let dateFormatter = DateFormatter()
    
    init() {
        defer {
            let _ = try? db.run(schedules.create(ifNotExists: true) { t in
                t.column(id)
                t.column(chapter)
                t.column(date)
                t.column(isOnDay, defaultValue: false)
                t.column(isLate, defaultValue: false)
                t.primaryKey(id, chapter, date)
            })
        }
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        self.db = try? Connection("\(path)/schedules.sqlite3")
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func insert(id: Int,
                chapter: String,
                date: Date,
                isOnDay: Bool = false,
                isLate: Bool = false) {
        
        let _ = try? self.db.run(schedules.insert(
            self.id <- id,
            self.chapter <- chapter,
            self.date <- self.dateFormatter.string(from: date),
            self.isOnDay <- isOnDay,
            self.isLate <- isLate
        ))
    }
    
    func select(of date: Date) -> [String] {
        guard let row = try? db.prepare(
            schedules.filter(
                self.date == dateFormatter.string(from: date)
            )
        ) else { return [] }
        return row
            .map { $0[chapter] }
    }
}
