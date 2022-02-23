//
//  ViewVIPViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs
import RxSwift
import UIKit
import PanModal
import ReactorKit
import RxKeyboard

enum NewVIPPresentableAction {
    case close
    case typeName(String)
    case typeDescription(String)
    case done
}

protocol NewVIPPresentableListener: class {
    var action: ActionSubject<NewVIPPresentableAction> { get }
    var state: Observable<NewVIPPresentableState> { get }
    var currentState: NewVIPPresentableState { get }
}

final class NewVIPViewController:
    BaseViewController,
    NewVIPPresentable,
    NewVIPViewControllable {

    // MARK: - Properties
    
    weak var listener: NewVIPPresentableListener?
    private var keyboardHeight: CGFloat = 0
    private var panModalHeight: CGFloat = 350
    
    // MARK: - Views
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var placeHolder: UILabel!
    @IBOutlet weak var descLength: UILabel!
    @IBOutlet weak var complete: UIButton!
    let border = CALayer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(listener: self.listener)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.border.frame = CGRect(x: 0, y: self.name.bounds.size.height-1,
                                   width: self.name.bounds.width, height: 1)
        self.border.backgroundColor = UIColor.black.cgColor
        self.name.layer.addSublayer(self.border)
    }
    
    override func attribute() {
        self.complete.layer.cornerRadius = 10
        self.desc.textContainer.maximumNumberOfLines = 3
        self.desc.textContainer.lineBreakMode = .byTruncatingTail
        self.desc.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Private methods
    
    private func bind(listener: NewVIPPresentableListener?) {
        guard let listener = listener else { return }
        
        self.bindActions(to: listener)
        self.bindState(from: listener)
    }
    
    private func bindActions(to listener: NewVIPPresentableListener) {
        self.bindViewDidDisappear(
            to: listener,
            isDismissing: self.isDismissing
        )
        self.bindName(to: listener)
        self.bindKeyboard()
        self.bindDesc(to: listener)
        self.bindComplete(to: listener)
    }
    
    private func bindState(from listener: NewVIPPresentableListener) {}
}

extension NewVIPViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(self.panModalHeight + self.keyboardHeight)
    }

    var longFormHeight: PanModalHeight {
        shortFormHeight
    }
}


extension NewVIPViewController {
    static func initWithStoryBoard() -> NewVIPViewController {
        NewVIPViewController.withStoryboard(storyboard: .newVIP)
    }
}

extension NewVIPViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
        let newLines = text.components(separatedBy: CharacterSet.newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        if(text == "\n") {
            return linesAfterChange <= textView.textContainer.maximumNumberOfLines
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 60
    }
}

extension NewVIPViewController {
    
    // MARK: - Binding Action
    
    func bindViewDidDisappear(to listener: NewVIPPresentableListener,
                              isDismissing: Bool) {
        self.rx.viewDidDisappear
            .filter { _ in isDismissing }
            .map { _ in .close }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindName(to listener: NewVIPPresentableListener) {
        self.name.rx.text.orEmpty
            .subscribe(onNext: { [weak self] in
                self?.complete.isEnabled = !$0.isEmpty
                self?.complete.backgroundColor = $0.isEmpty ? .lightGray : .black
            })
            .disposed(by: self.disposeBag)
        
        self.name.rx.text.orEmpty
            .map { .typeName($0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindComplete(to listener: NewVIPPresentableListener) {
        self.complete.rx.tap
            .map { .done }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }
    
    func bindKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] in
                self?.keyboardHeight = $0
                self?.panModalSetNeedsLayoutUpdate()
                if $0 > 0 {
                    self?.panModalTransition(to: .longForm)
                }
                
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindDesc(to listener: NewVIPPresentableListener) {
        self.desc.rx.text.orEmpty
            .map { !$0.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.placeHolder.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        self.desc.rx.text.orEmpty
            .map { .typeDescription($0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
        
        self.desc.rx.text.orEmpty
            .map { $0.count }
            .map { "(0\($0)/60)" }
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.descLength.rx.text)
            .disposed(by: self.disposeBag)
    }
}
