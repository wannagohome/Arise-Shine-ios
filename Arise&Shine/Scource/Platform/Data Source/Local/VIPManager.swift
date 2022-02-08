//
//  VIPManager.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/29.
//

import Foundation
import SQLite

struct VIPManager {
    
    static private let tableName = "vip"
    private let db: Connection!
    private let table = Table(VIPManager.tableName)
    private let id = Expression<Int>("id")
    private let image = Expression<String?>("image")
    private let name = Expression<String>("name")
    private let description = Expression<String>("description")
    private let phoneNumber = Expression<String?>("phoneNumber")
    private let birthday = Expression<String?>("birthday")
    private let lastPrayer = Expression<String?>("String")
    private let dateFormatter = DateFormatter()
    
    init() {
        defer {
            let _ = try? db.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(image, defaultValue: nil)
                t.column(name)
                t.column(description)
                t.column(phoneNumber, defaultValue: nil)
                t.column(birthday, defaultValue: nil)
                t.column(lastPrayer, defaultValue: nil)
            })
        }
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        self.db = try? Connection("\(path)/\(VIPManager.tableName).sqlite3")
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func insert(vip: VIP) {
        let _ = try? self.db.run(table.insert(
            self.name <- vip.name,
            self.image <- vip.image,
            self.description <- vip.description,
            self.phoneNumber <- vip.phoneNumber,
            self.birthday <- vip.birthday,
            self.lastPrayer <- vip.lastPrayer
        ))
    }
    
    func selectAll() -> [VIP] {
        guard let result = try? db.prepare(table) else { return [] }
        
        return result
            .map {
                VIP(id: $0[id],
                    image: $0[image],
                    name: $0[name],
                    description: $0[description],
                    phoneNumber: $0[phoneNumber],
                    birthday: $0[birthday],
                    lastPrayer: $0[lastPrayer])
            }
    }
}
