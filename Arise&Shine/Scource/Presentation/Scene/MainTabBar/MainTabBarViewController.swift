//
//  MainTabBarViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs
import RxSwift
import UIKit

protocol MainTabBarPresentableListener: AnyObject {}

final class MainTabBarViewController:
    UITabBarController,
    MainTabBarPresentable,
    MainTabBarViewControllable {
    
    // MARK: - Properties
    
    weak var listener: MainTabBarPresentableListener?
    
    // MARK: - Initialization

    init(viewControllers: [UINavigationController]) {
      super.init(nibName: nil, bundle: nil)
      modalPresentationStyle = .fullScreen
      setViewControllers(viewControllers, animated: false)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}
