//
//  BibleManager.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import Foundation
import SQLite


struct BibleManager {
    
    enum BibleType: String {
        case kor = "Kor"
    }
    
    private let type: BibleType
    private let bible = Table("bible")
    private let sentence = Expression<String>("sentence")
    private let book = Expression<Int>("book")
    private let chapter = Expression<Int>("chapter")
    private let longLabel = Expression<String>("long_label")
    
    init(of type: BibleType) {
        self.type = type
    }
    
    func getVerses(of bookNumber: Int, chapterNumber: Int) -> [String]? {
        guard let bundlePath = Bundle.main.path(forResource: self.type.rawValue,
                                                ofType: "sqlite3"),
              let db = try? Connection(bundlePath, readonly: true) else {
            return nil
        }
        
        let query = bible
            .select(sentence)
            .filter(book == bookNumber && chapter == chapterNumber)
        
        return try? db.prepare(query)
            .map { $0[sentence] }
    }
    
    func getBookName(of bookNumber: Int) -> String? {
        guard let bundlePath = Bundle.main.path(forResource: self.type.rawValue,
                                                ofType: "sqlite3"),
              let db = try? Connection(bundlePath, readonly: true) else {
            return nil
        }
        
        let query = bible
            .select(longLabel)
            .filter(book == bookNumber)
            .group(book)
        
        return try? db.prepare(query)
            .map { $0[longLabel] }
            .first
    }
    
    func getBookNames() -> [String]? {
        guard let bundlePath = Bundle.main.path(forResource: self.type.rawValue,
                                                ofType: "sqlite3"),
              let db = try? Connection(bundlePath, readonly: true) else {
            return nil
        }
        
        let query = bible
            .select(longLabel)
            .group(book)
        
        return try? db.prepare(query)
            .map { $0[longLabel] }
    }
    
    func getChapters(of bookNumber: Int) -> [String]? {
        guard let bundlePath = Bundle.main.path(forResource: self.type.rawValue,
                                                ofType: "sqlite3"),
              let db = try? Connection(bundlePath, readonly: true) else {
            return nil
        }
        
        let query = bible
            .select(chapter)
            .filter(book == bookNumber)
            .group(chapter)
        
        return try? db.prepare(query)
            .map { $0[chapter] }
            .map { String($0) }
    }
}
