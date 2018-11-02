import Foundation
import ObjectMapper

class IntStringTransform: TransformType {

    typealias Object = Int
    typealias JSON = AnyObject

    func transformFromJSON(_ value: Any?) -> Int? {
        if let value = value as? Int {
            return value
        }
        if let value = value as? String {
            return Int(value)
        }
        return nil
    }

    func transformToJSON(_ value: Int?) -> AnyObject? {
        return value as AnyObject
    }
}

class ListTransform<T: Mappable>: TransformType {
    typealias Object = [T]
    typealias JSON = [AnyObject]

    let mapper = Mapper<T>()

    func transformFromJSON(_ value: Any?) -> [T]? {
        guard let jsons = value as? [AnyObject] else { return nil }
        let objects = jsons.map { mapper.map(JSONObject: $0) }.compactMap { $0 }
        return objects
    }

    func transformToJSON(_ value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json as AnyObject)
            }
        }
        return results
    }
}

class DateTransform: TransformType {
    typealias Object = Date
    typealias JSON = Int

    func transformFromJSON(_ value: Any?) -> Date? {
        if let unixTime = value as? Int {
            return Date(timeIntervalSince1970: TimeInterval(unixTime))
        }
        return nil
    }

    func transformToJSON(_ value: Date?) -> Int? {
        if let date = value {
            return Int(date.timeIntervalSince1970)
        }
        return nil
    }
}
