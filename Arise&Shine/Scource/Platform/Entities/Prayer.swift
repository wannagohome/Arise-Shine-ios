//
//  Prayer.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import Foundation

struct Prayer: Equatable {
    var id: Int?
    var createdAt: String?
    var contents: String?
    var vipID: Int?
    var isOpened: Bool = false
    var createdDate: Date? {
        guard self.createdAt != nil else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self.createdAt!)
    }
}
