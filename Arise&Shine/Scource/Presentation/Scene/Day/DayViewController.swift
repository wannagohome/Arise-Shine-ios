//
//  DayViewController.swift
//  Arise&Shine
//
//  Created by Jinho Jang on 2021/01/23.
//

import RIBs
import RxSwift
import UIKit

protocol DayPresentableListener: class {
    var todayChapters: Observable<[String]> { get }
}

final class DayViewController: BaseViewController, DayPresentable, DayViewControllable {

    weak var listener: DayPresentableListener?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listener?.todayChapters
            .asDriver(onErrorDriveWith: .empty())
            .drive(self.tableView.rx.items) { tb, row, item in
                let cell = tb.dequeueReusableCell(withIdentifier: UITableViewCell.description(),
                                                  for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    override func attribute() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    }
}

extension DayViewController {
    static func initWithStoryBoard() -> DayViewController {
        DayViewController.withStoryboard(storyboard: .day)
    }
}
