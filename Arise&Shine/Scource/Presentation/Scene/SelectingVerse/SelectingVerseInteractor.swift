//
//  SelectingVerseInteractor.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import RIBs
import RxSwift

protocol SelectingVerseRouting: ViewableRouting {}

protocol SelectingVersePresentable: Presentable {
    var listener: SelectingVersePresentableListener? { get set }
}

protocol SelectingVerseListener: class {
    func cancleSelecting()
}

final class SelectingVerseInteractor:
    PresentableInteractor<SelectingVersePresentable>,
    SelectingVerseInteractable,
    SelectingVersePresentableListener {
    
    // MARK: - Properties

    weak var router: SelectingVerseRouting?
    weak var listener: SelectingVerseListener?

    // MARK: - Initialization
    
    override init(presenter: SelectingVersePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    func cancleSelecting() {
        self.listener?.cancleSelecting()
    }
}
