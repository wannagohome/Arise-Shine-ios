//
//  BibleFontViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/26.
//

import RIBs
import RxSwift
import ReactorKit
import UIKit
import PanModal

enum BibleFontPresentableAction {
    case sizeUp
    case sizeDown
    case close
}

protocol BibleFontPresentableListener: class {
    var action: ActionSubject<BibleFontPresentableAction> { get }
    var state: Observable<BibleFontPresentableState> { get }
    var currentState: BibleFontPresentableState { get }
}

final class BibleFontViewController:
    BaseViewController,
    BibleFontPresentable,
    BibleFontViewControllable {
    
    // MARK: - Properites

    weak var listener: BibleFontPresentableListener?
    
    // MARK: - Views
    
    @IBOutlet weak var sizeUpButton: UIButton!
    @IBOutlet weak var sizeDownButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
    }
    
    // MARK: - Private methods
    
    private func bind(listener: BibleFontPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: BibleFontPresentableListener) {
        self.bindTapSizeUp(to: listener)
        self.bindTapSizeDown(to: listener)
        self.bindViewDidDisappear(to: listener,
                                  isDismissing: self.isDismissing)
    }
    
    private func bindState(from listener: BibleFontPresentableListener) {}
}

// MARK: - PanModalPresentable

extension BibleFontViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(200)
    }

    var longFormHeight: PanModalHeight {
        shortFormHeight
    }
}


extension BibleFontViewController {
    static func initWithStoryBoard() -> BibleFontViewController {
        BibleFontViewController.withStoryboard(storyboard: .bibleFont)
    }
}

private extension BibleFontViewController {
    
    // MARK: - Binding Action
    
    func bindTapSizeUp(to listener: BibleFontPresentableListener) {
        self.sizeUpButton.rx.tap
            .map { _ in .sizeUp }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }

    func bindTapSizeDown(to listener: BibleFontPresentableListener) {
        self.sizeDownButton.rx.tap
            .map { _ in .sizeDown }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindViewDidDisappear(to listener: BibleFontPresentableListener,
                              isDismissing: Bool) {
        self.rx.viewDidDisappear
            .filter { _ in isDismissing }
            .map { _ in .close }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
}
