//
//  BibleBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import Foundation
import RIBs

protocol BibleDependency: Dependency {
    var bibleViewController: BiblePresentable & BibleViewControllable { get }
}

final class BibleComponent:
    Component<BibleDependency>,
    SelectDependency,
    BibleFontDependency,
    SelectingVerseDependency {
    
    var currentChapter = BibleChapter(type: .kor,
                                      book: UserDefaults.integer(forKey: .bookNumber) == 0 ? 1
                                        : UserDefaults.integer(forKey: .bookNumber),
                                      chapter: UserDefaults.integer(forKey: .chapterNumber) == 0 ? 1
                                        : UserDefaults.integer(forKey: .chapterNumber))
    
    fileprivate var initialState: BiblePresentableState {
        .init(currentChapter: self.currentChapter,
              verses: self.currentChapter.verses!
                .map { BibleVerse(sentence: $0,
                                  isSelected: false,
                                  fontSize: 14) }
        )
    }
    
    fileprivate var bibleViewController: BiblePresentable & BibleViewControllable {
        self.dependency.bibleViewController
    }
}

// MARK: - Builder

protocol BibleBuildable: Buildable {
    func build(withListener listener: BibleListener) -> BibleRouting
}

final class BibleBuilder: Builder<BibleDependency>, BibleBuildable {
    
    override init(dependency: BibleDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BibleListener) -> BibleRouting {
        let component = BibleComponent(dependency: dependency)
        let interactor = BibleInteractor(presenter: component.bibleViewController,
                                         initialState: component.initialState)
        interactor.listener = listener
        
        let selectBuilder = SelectBuilder(dependency: component)
        let bibleFontBuilder = BibleFontBuilder(dependency: component)
        let selectingVerseBuilder = SelectingVerseBuilder(dependency: component)
        return BibleRouter(interactor: interactor,
                           viewController: component.bibleViewController,
                           selectBuilder: selectBuilder,
                           bibleFontBuilder: bibleFontBuilder,
                           selectingVerseBuilder: selectingVerseBuilder)
    }
}

