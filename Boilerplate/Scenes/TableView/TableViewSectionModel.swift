//
//  SectionModel.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import Foundation
import RxDataSources

struct TableViewSectionModel {
    let header: String
    var gits: [Item]
    init(header: String, gits: [Item]) {
        self.header = header
        self.gits = gits
    }
}

extension TableViewSectionModel: SectionModelType, AnimatableSectionModelType {
    typealias Item = GithubCellModel
    typealias Identity = String
    var identity: String { return header }
    var items: [Item] { return gits }
    init(original: TableViewSectionModel, items: [Item]) {
        self = original
        self.gits = items
    }
}

extension GithubCellModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return String(id)
    }
}

func == (lhs: GithubCellModel, rhs: GithubCellModel) -> Bool {
    return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.nickname == rhs.nickname
        && lhs.URL == rhs.URL
}
