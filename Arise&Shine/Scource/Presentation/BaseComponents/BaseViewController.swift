//
//  BaseViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    var isDismissing: Bool {
        self.isMovingFromParent || self.isBeingDismissed
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.attribute()
        self.layout()
    }
    
    // MARK: - Initialization & Deinitialization
    
    override func awakeFromNib() {
        self.initialize()
    }
    
    @objc func initialize() {}
    @objc func attribute() {}
    func layout() {}
}
