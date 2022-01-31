//
//  UserDefaults + Ex.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/27.
//

import Foundation

enum UserDefaultKey: String {
    case bookNumber = "BookNumber"
    case chapterNumber = "ChapterNumber"
    case onGoing = "onGoing"
}


extension UserDefaults {
    static func set(_ value: Int,
                    forKey defaultName: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func set(_ value: String,
                    forKey defaultName: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func set(_ value: Float,
                    forKey defaultName: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func set(_ value: Double,
                    forKey defaultName: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func set(_ value: Bool,
                    forKey defaultName: UserDefaultKey) {
        UserDefaults.standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func string(forKey defaultName: UserDefaultKey) -> String? {
        UserDefaults.standard.string(forKey: defaultName.rawValue)
    }
    
    static func bool(forKey defaultName: UserDefaultKey) -> Bool {
        UserDefaults.standard.bool(forKey: defaultName.rawValue)
    }
    
    static func integer(forKey defaultName: UserDefaultKey) -> Int {
        UserDefaults.standard.integer(forKey: defaultName.rawValue)
    }
}
