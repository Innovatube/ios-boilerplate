//
//  Environment.swift
//  Boilerplate
//
//  Created by Do Dinh Thy  Son  on 1/5/18.
//  Copyright © 2018 Innovatube. All rights reserved.
//

import Foundation

extension Bundle {
    var baseURL : URL {
        guard let stringURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("Missing BASE_URL value in info.plist")
        }
        guard let url = URL(string:"https://" + stringURL) else {
            fatalError("Cannot construct url from stirng")
        }
        return url
    }
}
