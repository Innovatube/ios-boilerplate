//
//  ViewController.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewModel
import RxDataSources

protocol TableViewModelType {
    var gits: Driver<[TableViewSectionModel]> { get }
    var hasData: Variable<Bool> { get }
}

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate let disposeBag = DisposeBag()
    let dataSource = configureDataSource()
    var viewModel: TableViewModelType! = TableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tableview with cache"
        configureView()
        configure(viewModel: viewModel)
    }

}

extension TableViewController {
    func configureView() {
        tableView.registerNib(forCellType: GitCell.self)
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
    }
    static func configureDataSource() -> RxTableViewSectionedAnimatedDataSource<TableViewSectionModel> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .left),

            configureCell: {(_, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(type: GitCell.self, for: indexPath)
                cell.nameLabel.text = item.name
            return cell
        })
    }
    func configure(viewModel: TableViewModelType) {
        bindTo(viewModel: viewModel)
    }
    func bindTo(viewModel: TableViewModelType) {
        viewModel.gits
            .drive ((tableView.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
        viewModel.hasData
            .asObservable()
            .subscribe(onNext: { isData in
                if isData { print("has data ")
                } else { print("data is empty") }
            }).disposed(by: disposeBag)

    }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(forCellType type: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    func registerNib<T: UITableViewCell>(forCellTypes types: [T.Type]) where T: ReusableView, T: NibLoadableView {
        for type in types {
            registerNib(forCellType: type)
        }
    }
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
