import Foundation

/*
 * thanks to:
 * https://github.com/tattn/DataConvertible
 */

public protocol DataConvertible {
    init(_ data: Data) throws
    func convertToData() throws -> Data
}

public extension DataConvertible where Self: Decodable {
    init(_ data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

public extension DataConvertible where Self: Encodable {
    func convertToData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public protocol DataConvertibleStore {
    func set(_ value: DataConvertible, forKey key: String) throws
    func value<T: DataConvertible>(_ type: T.Type, forKey key: String) throws -> T?
}
