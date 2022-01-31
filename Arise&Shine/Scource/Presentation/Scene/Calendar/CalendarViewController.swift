//
//  CalendarViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs
import RxSwift
import UIKit
import SnapKit

protocol CalendarPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CalendarViewController:
    BaseViewController,
    CalendarPresentable {
    
    // MARK: - Properties

    weak var listener: CalendarPresentableListener?
    private let mothViewHeight: CGFloat = 350
    
    // MARK: - Initialization
    
    override func initialize() {
        self.setTabBarItem()
    }
    
    // MARK: - Private methods
    
    private func setTabBarItem() {
        let item = UITabBarItem(title: "Calendar",
                                image: UIImage(systemName: "calendar"),
                                tag: 1)
        item.badgeColor = .green
        tabBarItem = item
    }
}

extension CalendarViewController {
    static func initWithStoryBoard() -> CalendarViewController {
        CalendarViewController.withStoryboard(storyboard: .calendar)
    }
}


extension CalendarViewController: CalendarViewControllable {
    func addMonth(viewController: ViewControllable) {
        guard let monthView = viewController.uiviewController.view else { return }
        
        self.addChild(viewController.uiviewController)
        self.view.addSubview(monthView)
        
        monthView.snp.makeConstraints { m in
            m.top.equalTo(self.view.safeAreaLayoutGuide)
            m.leading.equalTo(self.view.safeAreaLayoutGuide)
            m.trailing.equalTo(self.view.safeAreaLayoutGuide)
            m.height.equalTo(self.mothViewHeight)
        }
        
        viewController.uiviewController.didMove(toParent: self)
    }
    
    func addDay(viewController: ViewControllable) {
        guard let dayView = viewController.uiviewController.view else { return }
        
        self.addChild(viewController.uiviewController)
        self.view.addSubview(dayView)
        
        dayView.snp.makeConstraints { m in
            m.edges.equalTo(self.view.safeAreaLayoutGuide)
                .inset(UIEdgeInsets(top: self.mothViewHeight, left: 0, bottom: 0, right: 0))
        }
    }
}
