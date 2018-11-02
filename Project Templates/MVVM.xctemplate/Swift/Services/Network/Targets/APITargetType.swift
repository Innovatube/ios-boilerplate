//
//  APITarget.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Alamofire
import Moya

class StubClass {}

protocol APITargetType: TargetType, AccessTokenAuthorizable {
    var parameters: [String: Any]? { get }

    var sampleDataFileName: String { get }
}

extension APITargetType {

    /// The target's base `URL`.
    // swiftlint:disable force_unwrapping
    var baseURL: URL {
        return URL(string: ___PROJECTNAME___ClientAPIKeys.basePath)!
    }
    // swiftlint:enable force_unwrapping

    /// The type of HTTP task to be performed.
    var task: Task {
        let encoding: ParameterEncoding
        switch method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }

    /// The headers to be used in the request.
    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any]? {
        return nil
    }

    var authorizationType: AuthorizationType {
        return .none
    }

    var sampleData: Data {
        return stubbedResponse(sampleDataFileName)
    }

    func stubbedResponse(_ filename: String) -> Data {
        let bundle = Bundle(for: StubClass.self)
        if let path = bundle.path(forResource: filename, ofType: "json"),
            let data = (try? Data(contentsOf: URL(fileURLWithPath: path))) {
            return data
        }
        return Data()
    }
}
