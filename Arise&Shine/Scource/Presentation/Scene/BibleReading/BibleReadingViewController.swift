//
//  BibleReadingViewController.swift
//  Arise&Shine
//
//  Created by wemeet_pete on 2021/04/13.
//

import RIBs
import RxSwift
import UIKit

protocol BibleReadingPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class BibleReadingViewController:
    BaseViewController,
    BibleReadingPresentable,
    BibleReadingViewControllable {

    weak var listener: BibleReadingPresentableListener?
    
    // MARK: - Inheritance
    
    override func initialize() {
        self.setTabBarItem()
    }
    
    // MARK: - Private methods
    
    private func setTabBarItem() {
        let item = UITabBarItem(title: "Bible",
                                image: UIImage(systemName: "books.vertical"),
                                tag: 1)
        item.badgeColor = .green
        tabBarItem = item
    }
}

extension BibleReadingViewController {
    static func initWithStoryBoard() -> BibleReadingViewController {
        BibleReadingViewController.withStoryboard(storyboard: .bibleReading)
    }
}
