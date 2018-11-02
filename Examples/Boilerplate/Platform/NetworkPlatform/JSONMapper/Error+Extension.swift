import Foundation
import Action
import Moya

extension ActionError {
    var underlyingError: Swift.Error? {
        switch self {
        case .underlyingError(let error):
            return error

        case .notEnabled:
            return nil
        }
    }

    var message: String {
        switch self {
        case .underlyingError(let error):
            return error.message

        case .notEnabled:
            return "Action not enabled".localized
        }
    }
}

extension MoyaError {
    var serverError: ServerError? {
        guard case .underlying(let error) = self else { return nil }
        guard let serverError = error.0 as? ServerError else { return nil }
        return serverError
    }
}

// swiftlint:disable force_cast
extension Swift.Error {
    var message: String {
        switch self {
        case is MoyaError:
            let moyaError = self as! MoyaError
            if let serverError = moyaError.serverError {
                return serverError.detail ?? ""
            }

            switch moyaError {
            case .underlying(let error):
                return error.0.localizedDescription

            default:
                return localizedDescription
            }

        case is ActionError:
            let actionError = self as! ActionError
            return actionError.message

        default:
            return localizedDescription
        }
    }
}

// swiftlint:enable force_cast
