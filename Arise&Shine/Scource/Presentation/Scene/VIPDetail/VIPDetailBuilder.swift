//
//  VIPDetailBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/30.
//

import RIBs

protocol VIPDetailDependency: Dependency {}

final class VIPDetailComponent: Component<VIPDetailDependency> {}

// MARK: - Builder

protocol VIPDetailBuildable: Buildable {
    func build(withListener listener: VIPDetailListener,
               vip: VIP) -> VIPDetailRouting
}

final class VIPDetailBuilder:
    Builder<VIPDetailDependency>,
    VIPDetailBuildable {

    override init(dependency: VIPDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: VIPDetailListener,
               vip: VIP) -> VIPDetailRouting {
        let _ = VIPDetailComponent(dependency: dependency)
        let viewController = VIPDetailViewController.initWithStoryBoard()
        let interactor = VIPDetailInteractor(presenter: viewController,
                                             initialState: .init(vip: vip))
        interactor.listener = listener
        return VIPDetailRouter(interactor: interactor,
                               viewController: viewController)
    }
}
