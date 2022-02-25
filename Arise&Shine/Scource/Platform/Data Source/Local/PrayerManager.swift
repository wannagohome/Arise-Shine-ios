//
//  PrayerManager.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import Foundation
import SQLite

struct PrayerManager {
    
    static private let tableName = "prayer"
    private let db: Connection!
    private let table = Table(PrayerManager.tableName)
    private let id = Expression<Int>("id")
    private let createdAt = Expression<String?>("createdAt")
    private let contents = Expression<String?>("contents")
    private let vipID = Expression<Int?>("vipID")
    
    
    init() {
        defer {
            let _ = try? db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(createdAt)
                t.column(contents)
                t.column(vipID)
            })
        }
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        self.db = try? Connection("\(path)/\(PrayerManager.tableName).sqlite3")
    }
    
    func insert(prayer: Prayer) {
        let _ = try? self.db.run(table.insert(
            self.createdAt <- prayer.createdAt,
            self.contents <- prayer.contents,
            self.vipID <- prayer.vipID
        ))
    }
    
    func selectAll(of vipID: Int) -> [Prayer] {
        let query = table.filter(self.vipID == vipID)
        guard let result = try? db.prepare(query) else { return [] }
        
        return result
            .map {
                Prayer(id: $0[id],
                       createdAt: $0[createdAt],
                       contents: $0[contents])
            }
    }
    
    func updateContents(of prayer: Prayer) {
        guard prayer.id != nil else { return }
        let newPrayer = table.filter(id == prayer.id!)
        
        let _ = try? self.db.run(newPrayer.update(
            contents <- prayer.contents
        ))
    }
}
