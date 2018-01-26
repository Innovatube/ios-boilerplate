//
//  Github.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

protocol GithubType {
    var id: String { get set }
    var name: String { get set }
    var nickname: String { get set }
    var URL: String { get set }
}

class Github: Object, GithubType {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var URL: String = ""
    required convenience init?(map: Map) {
        self.init()
        guard (map.JSON["id"] as? String) != nil else { return nil }
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Github: Mappable {
    func mapping(map: Map) {
        id <- map["id"]
        name  <- map["name"]
        nickname <- map["nickname"]
        URL <- map["url"]
    }
}
