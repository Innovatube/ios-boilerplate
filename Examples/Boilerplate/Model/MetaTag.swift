import Foundation

public struct MetaTag: Codable {

    public var tagName: String?
    public var taggedAt: String?

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(tagName, forKey: "tag_name")
        try container.encodeIfPresent(taggedAt, forKey: "tagged_at")
    }

    // Decodable protocol methods

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        tagName = try container.decodeIfPresent(String.self, forKey: "tag_name")
        taggedAt = try container.decodeIfPresent(String.self, forKey: "tagged_at")
    }
}

extension MetaTag: Equatable {
    public static func == (lhs: MetaTag, rhs: MetaTag) -> Bool {
        return lhs.tagName == rhs.tagName && lhs.taggedAt == rhs.taggedAt
    }
}
