//
//  NewPrayerViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs
import RxSwift
import ReactorKit
import UIKit
import PanModal

enum NewPrayerPresentableAction {
    case done(String)
    case close
}

protocol NewPrayerPresentableListener: class {
    var action: ActionSubject<NewPrayerPresentableAction> { get }
    var state: Observable<NewPrayerPresentableState> { get }
    var currentState: NewPrayerPresentableState { get }
}

final class NewPrayerViewController:
    BaseViewController,
    NewPrayerPresentable,
    NewPrayerViewControllable {

    // MARK: - Properties
    
    weak var listener: NewPrayerPresentableListener?
    private let heightForShort: CGFloat = 300
    
    // MARK: - Views
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    let doneButton = UIButton()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
        self.textView.becomeFirstResponder()
    }
    
    override func attribute() {
        self.doneButton.setTitle("완료", for: .normal)
        self.doneButton.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        let toolBarKeyboard = UIToolbar()
        toolBarKeyboard.sizeToFit()
        let btnDoneBar = UIBarButtonItem(customView: self.doneButton)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBarKeyboard.items = [flexSpace, btnDoneBar]
        self.textView.inputAccessoryView = toolBarKeyboard
    }
    
    // MARK: - Private methods
    
    private func bind(listener: NewPrayerPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
        self.bindTextView()
    }
    
    private func bindActions(to listener: NewPrayerPresentableListener) {
        self.bindViewDidDisappear(
            to: listener,
            isDismissing: self.isDismissing
        )
        self.bindTapDone(to: listener)
    }
    
    private func bindState(from listener: NewPrayerPresentableListener) {}
}

extension NewPrayerViewController {
    static func initWithStoryBoard() -> NewPrayerViewController {
        NewPrayerViewController.withStoryboard(storyboard: .newPrayer)
    }
}

extension NewPrayerViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
}


extension NewPrayerViewController {
    
    // MARK: - Binding Action
    
    func bindViewDidDisappear(to listener: NewPrayerPresentableListener,
                              isDismissing: Bool) {
        self.rx.viewDidDisappear
            .filter { _ in isDismissing }
            .map { _ in .close }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindTapDone(to listener: NewPrayerPresentableListener) {
        self.doneButton.rx.tap
            .withLatestFrom(self.textView.rx.text.orEmpty)
            .map { .done($0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindTextView() {
        self.textView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.placeholder.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
}
