//
//  SelectBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/13.
//

import RIBs

protocol SelectDependency: Dependency {
    var currentChapter: BibleChapter { get }
}

final class SelectComponent: Component<SelectDependency> {

    fileprivate var currentChapter: BibleChapter {
        self.dependency.currentChapter
    }
}

// MARK: - Builder

protocol SelectBuildable: Buildable {
    func build(withListener listener: SelectListener) -> SelectRouting
}

final class SelectBuilder:
    Builder<SelectDependency>,
    SelectBuildable {

    override init(dependency: SelectDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectListener) -> SelectRouting {
        let component = SelectComponent(dependency: dependency)
        let viewController = SelectViewController.initWithStoryBoard()
        let interactor = SelectInteractor(presenter: viewController,
                                          currentChapter: component.currentChapter)
        interactor.listener = listener
        
        
        return SelectRouter(interactor: interactor,
                            viewController: viewController)
    }
}
