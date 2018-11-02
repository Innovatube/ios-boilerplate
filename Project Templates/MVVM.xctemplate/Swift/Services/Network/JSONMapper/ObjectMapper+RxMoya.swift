import Moya
import ObjectMapper
import RxSwift

extension Response {

    func mapJSON(key: String) throws -> Any {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        guard let object = json[key] else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }

    func mapObject<T: Mappable>(_ type: T.Type, key: String, context: MapContext? = nil) throws -> T {
        guard let object = Mapper<T>(context: context).map(JSONObject: try mapJSON(key: key)) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }

    func mapArray<T: Mappable>(_ type: T.Type, key: String, context: MapContext? = nil) throws -> [T] {
        guard let json = try mapJSON(key: key) as? [[String: Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        return Mapper<T>(context: context).mapArray(JSONArray: json)
    }
}

extension ObservableType where E == Moya.Response {

    func mapJSON(key: String) -> Observable<Any?> {
        return flatMap { (response) -> Observable<Any?> in
            return Observable.just(try response.mapJSON(key: key))
        }
    }

    func mapObject<T: Mappable>(_ type: T.Type, key: String, context: MapContext? = nil) -> Observable<T> {
        return flatMap { (response) -> Observable<T> in
            return Observable.just(try response.mapObject(type, key: key, context: context))
        }
    }

    func mapArray<T: Mappable>(_ type: T.Type, key: String, context: MapContext? = nil) -> Observable<[T]> {
        return flatMap { (response) -> Observable<[T]> in
            return Observable.just(try response.mapArray(type, key: key, context: context))
        }
    }
}
