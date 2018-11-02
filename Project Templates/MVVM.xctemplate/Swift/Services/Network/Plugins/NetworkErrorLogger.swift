import Foundation
import Moya
import Moya_ObjectMapper
import Result

struct NetworkErrorLogger: PluginType {
    func didReceive(_ result: Result<Moya.Response, Moya.MoyaError>, target: TargetType) {

        switch result {
        case .success(let response):
            if (200...299).contains(response.statusCode) {
                return
            }

            do {
                let serverError = try response.mapObject(ServerError.self)
                debugPrint("\(target) -> \(serverError.localizedDescription)")

            } catch {
                debugPrint(error.message)
            }

        case .failure(let error):
            debugPrint(error.message)
        }
    }
}
