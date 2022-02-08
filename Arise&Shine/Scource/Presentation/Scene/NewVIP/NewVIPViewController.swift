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

enum NewVIPPresentableAction {
    case close
    case done(String)
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
    
    // MARK: - Views
    
    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var name: UITextField!
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
        let config = UIImage.SymbolConfiguration(pointSize: 60)
        self.profile.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        self.complete.layer.cornerRadius = 10
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
        self.bindName()
        self.bindComplete(to: listener)
    }
    
    private func bindState(from listener: NewVIPPresentableListener) {}
}

extension NewVIPViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(300)
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
    
    func bindName() {
        self.name.rx.text.orEmpty
            .subscribe(onNext: { [weak self] in
                self?.complete.isEnabled = !$0.isEmpty
                self?.complete.backgroundColor = $0.isEmpty ? .lightGray : .black
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindComplete(to listener: NewVIPPresentableListener) {
        self.complete.rx.tap
            .withLatestFrom(self.name.rx.text.orEmpty)
            .map { .done($0) }
            .bind(to: listener.action)
            .disposed(by: self.disposeBag)
    }    
}
