//
//  BibleChapter.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import Foundation

struct BibleChapter {
    
    private var manager: BibleManager {
        BibleManager(of: self.type)
    }
    
    var type: BibleManager.BibleType = .kor
    var book: Int = 1
    var chapter: Int = 1
    
    var bookName: String? {
        self.manager.getBookName(of: self.book)
    }
    
    var verses: [String]? {
        self.manager.getVerses(
            of: self.book,
            chapterNumber: self.chapter
        )
    }
}


struct BibleVerse {
    var sentence: String
    var isSelected: Bool = false
    var fontSize: Int
}
