//
//  BiblePresentableState.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

struct BiblePresentableState {
    var currentChapter: BibleChapter
    var verses: [BibleVerse]
    var isSelecting: Bool = false
}

struct SelectPresentableState {
    var selectedBookNumber: Int
    var chapters: [String]? {
        BibleManager(of: .kor)
            .getChapters(of: self.selectedBookNumber)
    }
}
