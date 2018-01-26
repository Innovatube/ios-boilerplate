//
//  GithubCellModel.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import Foundation
import RealmSwift

struct GithubCellModel {
    var id: String
    let name: String
    var nickname: String
    var URL: String
    init(_ gitHub: Github) {
        id = gitHub.id
        name = gitHub.name
        nickname = gitHub.nickname
        URL = gitHub.URL
    }
}
