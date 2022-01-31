//
//  ChildViewControllable.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import UIKit
import RIBs

protocol ChildViewControllable: ViewControllable {
    var parent: UIViewController? { get }
}
