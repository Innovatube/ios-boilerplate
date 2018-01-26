//
//  ViewModel.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import Foundation
import RxSwift
import RxViewModel
import RxCocoa

class TableViewModel: RxViewModel, TableViewModelType {
    var errors: Observable<Swift.Error> { return errorSubject.asObservable() }
    fileprivate let errorSubject: PublishSubject<Swift.Error> = PublishSubject<Swift.Error>()
    var gits: Driver<[TableViewSectionModel]>
    fileprivate let disposeBag = DisposeBag()
    var hasData: Variable<Bool> = Variable(false)
    override init() {
        let data = Github.observableGithub()
        gits = data.map { gits in
            let items = gits.map { GithubCellModel($0) }
            let sectionModels = [TableViewSectionModel(header: "git", gits: items)]
            return sectionModels
            }
            .asDriver(onErrorJustReturn: [])
        super.init()
        data.asObservable().map { data in
            if !data.isEmpty {
                return true
            } else { return false }
            }
            .bind(to: hasData)
            .disposed(by: disposeBag)
    }
}
