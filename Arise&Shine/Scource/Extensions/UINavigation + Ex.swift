//
//  UINavigation + Ex.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import UIKit

import RIBs

extension UINavigationController: ViewControllable {
  public var uiviewController: UIViewController { self }
  
  convenience init(root: ViewControllable) {
    self.init(rootViewController: root.uiviewController)
  }
}
