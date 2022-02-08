//
//  ViewVIPBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol NewVIPDependency: Dependency {
    
}

final class NewVIPComponent: Component<NewVIPDependency> {
    
}

// MARK: - Builder

protocol NewVIPBuildable: Buildable {
    func build(withListener listener: NewVIPListener) -> NewVIPRouting
}

final class NewVIPBuilder: Builder<NewVIPDependency>, NewVIPBuildable {

    override init(dependency: NewVIPDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NewVIPListener) -> NewVIPRouting {
        let _ = NewVIPComponent(dependency: dependency)
        let viewController = NewVIPViewController.initWithStoryBoard()
        let interactor = NewVIPInteractor(presenter: viewController,
                                          initialState: .init())
        interactor.listener = listener
        return NewVIPRouter(interactor: interactor,
                            viewController: viewController)
    }
}
