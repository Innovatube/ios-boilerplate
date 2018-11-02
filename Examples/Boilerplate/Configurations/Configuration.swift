import Foundation

struct Configuration {
    enum BuildType {
        /// for testing development env
        case development
        /// for testing staging env
        case staging
        /// for testing release env
        case production
        /// for release
        case release
    }

    static var buildType: BuildType = {

        // Environment variable used on launching which defined in each scheme
        if let environment = ProcessInfo.processInfo.environment["BUILD_TYPE"] {
            switch environment {
            case "STAGING": return .staging
            case "PRODUCTION": return .production
            default: break
            }
        }

        return .development
    }()
}

struct ExampleClientAPIKeys {
    #if DEBUG
    static let basePath = "https://pacific-sierra-30668.herokuapp.com/api/v1"
    static let clientID = ""
    static let clientSecret = ""

    #elseif STAGING
    static let basePath = "https://pacific-sierra-30668.herokuapp.com/api/v1"
    static let clientID = ""
    static let clientSecret = ""

    #elseif RELEASE
    static let basePath = "https://pacific-sierra-30668.herokuapp.com/api/v1"
    static let clientID = ""
    static let clientSecret = ""
    #endif
}

struct UserDefaultsKeys {
}
