//
//  User.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation

final class User: NSObject {

    let id: String
    let email: String
    let name: String

    init(id: String, email: String, name: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
