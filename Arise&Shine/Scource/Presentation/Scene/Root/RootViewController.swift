//
//  RootViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/11.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: class {}

final class RootViewController:
    UIViewController,
    RootPresentable,
    RootViewControllable {

    weak var listener: RootPresentableListener?
    
    func present(viewController: ViewControllable) {
        self.present(viewController.uiviewController, animated: false)
    }
}
