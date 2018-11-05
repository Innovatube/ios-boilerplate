import Foundation
import Moya
import Result
import ObjectMapper
import Moya_ObjectMapper

struct NetworkErrorTransformPlugin: PluginType {
    func process(_ result: Result<Moya.Response, Moya.MoyaError>, target: TargetType) -> Result<Moya.Response, Moya.MoyaError> {

        switch result {
        case .success(let response):
            if (200...299).contains(response.statusCode) {
                return result
            }

            do {
                let serverError = try response.mapObject(ServerError.self)
                return Result.failure(MoyaError.underlying(serverError, response))

            } catch {
                return Result.failure(MoyaError.underlying(error, response))
            }

        case .failure:
            return result
        }
    }
}
