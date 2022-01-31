//
//  BibleReadingSchedule.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/16.
//

import Foundation

struct BibleReadingSchedule: Equatable {
    let id: Int
    var startDate: Date?
    let schedule: [String]
    let title: String
}
