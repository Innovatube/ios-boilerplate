import Foundation
import Moya

enum ExampleTarget {
    case homeTop(limit: Int, offset: Int)
    case homeHeaders
}

extension ExampleTarget: APITargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: ___PROJECTNAME___ClientAPIKeys.basePath)!
        }
    }

    var path: String {
        switch self {
        case .homeTop:
            return "/articles/top/hairsalon"
        case .homeHeaders:
            return "/headers"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var sampleDataFileName: String {
        switch self {
        case .homeTop:
            return "home_top"
        case .homeHeaders:
            return "home_headers"
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = [:]
        let currentToken = TokenKeychainStore.default.currentToken
        if let accessToken = currentToken.accessToken, let tokenType = currentToken.tokenType?.capitalized {
            headers["Authorization"] = "\(tokenType) \(accessToken)"
        }
        if let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString {
            headers["identifier_for_vendor"] = identifierForVendor
        }

        return headers
    }

    var parameters: [String: Any]? {
        switch self {
        case .homeTop(let limit, let offset):
            return [
                "limit": limit,
                "offset": offset
            ]
        case .homeHeaders:
            return ["type": "hairsalon"]
        }
    }
}
