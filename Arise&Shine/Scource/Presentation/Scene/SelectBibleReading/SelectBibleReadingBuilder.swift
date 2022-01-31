//
//  SelectBibleReadingBuilder.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/15.
//

import Foundation
import RIBs

protocol SelectBibleReadingDependency: Dependency {}

final class SelectBibleReadingComponent: Component<SelectBibleReadingDependency> {}

// MARK: - Builder

protocol SelectBibleReadingBuildable: Buildable {
    func build(withListener listener: SelectBibleReadingListener) -> SelectBibleReadingRouting
}

final class SelectBibleReadingBuilder: Builder<SelectBibleReadingDependency>, SelectBibleReadingBuildable {

    override init(dependency: SelectBibleReadingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SelectBibleReadingListener) -> SelectBibleReadingRouting {
        let _ = SelectBibleReadingComponent(dependency: dependency)
        let viewController = SelectBibleReadingViewController.initWithStoryBoard()
        let interactor = SelectBibleReadingInteractor(presenter: viewController,
                                                      initialState: SelectBibleReadingPresentableState(schedules: [
                                                        BibleReadingSchedule(id: 1, startDate: Date(), schedule: [
                                                            "20:1,1:1-6,19:1", "20:2,1:7-12,19:2", "20:3,1:13-18,19:3",
                                                            "20:4,1:19-23,19:4", "20:5,1:24-26,19:5", "20:6,1:27-30,19:6",
                                                            "20:7,1:31-34,19:7", "20:8,1:35-38,19:8", "20:9,1:39-42,19:9",
                                                            "20:10,1:43-46,19:10", "20:11,1:47-50,19:11", "20:12,2:1-5,19:12",
                                                            "20:13,2:6-9,19:13", "20:14,2:10-13,19:14", "20:15,2:14-17,19:15",
                                                            "20:16,2:18-21,19:16", "20:17,2:22-26,19:17", "20:18,2:27-29,19:18",
                                                            "20:19,2:30-33,19:19", "20:20,2:34-36,19:20", "20:21,2:37-40,19:21",
                                                            "20:22,3:1-5,19:22", "20:23,3:6-9,19:23", "20:24,3:10-13,19:24",
                                                            "20:25,3:14-17,19:25", "20:26,3:18-21,19:26", "20:27,3:22-24,19:27",
                                                            "20:28,3:25-27,19:28", "20:29,4:1-3,19:29", "20:30,4:4-6,19:30",
                                                            "20:31,4:7-9,19:31", "20:1,4:10-12,19:32", "20:2,4:13-15,19:33",
                                                            "20:3,4:16-19,19:34", "20:4,4:20-23,19:35", "20:5,4:24-27,19:36",
                                                            "20:6,4:28-31,19:37", "20:7,4:32-36,19:38", "20:8,5:1-3,19:39",
                                                            "20:9,5:4-6,19:40", "20:10,5:7-10,19:41", "20:11,5:11-14,19:42",
                                                            "20:12,5:15-19,19:43", "20:13,5:20-24,19:44", "20:14,5:25-28,19:45",
                                                            "20:15,5:29-31,19:46", "20:16,5:32-34,19:47",
                                                        ], title: "모세 오경")
                                                      ]))
        interactor.listener = listener
        return SelectBibleReadingRouter(interactor: interactor, viewController: viewController)
    }
}
