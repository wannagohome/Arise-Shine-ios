//
//  SelectingVerseViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs
import RxSwift
import UIKit

protocol SelectingVersePresentableListener: AnyObject {
    func cancleSelecting()
}

final class SelectingVerseViewController:
    BaseViewController,
    SelectingVersePresentable,
    SelectingVerseViewControllable {

    // MARK: - Properties
    
    weak var listener: SelectingVersePresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var cancleButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    private func bind(listener: SelectingVersePresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: SelectingVersePresentableListener) {
        self.bindTapCancleButton(to: listener)
    }
    
    private func bindState(from listener: SelectingVersePresentableListener) {}
}


extension SelectingVerseViewController {
    
    func bindTapCancleButton(to listener: SelectingVersePresentableListener) {
        self.cancleButton.rx.tap
            .subscribe(onNext: { listener.cancleSelecting() })
            .disposed(by: self.disposeBag)
    }
}
