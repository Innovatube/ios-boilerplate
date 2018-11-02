import Foundation

/** Error response media type (default view) */

public struct ModelError: Codable {

    /** an application-specific error code, expressed as a string value. */
    public var code: String?
    /** a human-readable explanation specific to this occurrence of the problem. */
    public var detail: String?
    /** a unique identifier for this particular occurrence of the problem. */
    public var id: String?
    /** a meta object containing non-standard meta-information about the error. */
    public var meta: String?
    /** the HTTP status code applicable to this problem, expressed as a string value. */
    public var status: String?

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(code, forKey: "code")
        try container.encodeIfPresent(detail, forKey: "detail")
        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(meta, forKey: "meta")
        try container.encodeIfPresent(status, forKey: "status")
    }

    // Decodable protocol methods

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        code = try container.decodeIfPresent(String.self, forKey: "code")
        detail = try container.decodeIfPresent(String.self, forKey: "detail")
        id = try container.decodeIfPresent(String.self, forKey: "id")
        meta = try container.decodeIfPresent(String.self, forKey: "meta")
        status = try container.decodeIfPresent(String.self, forKey: "status")
    }
}
