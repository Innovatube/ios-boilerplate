import Foundation

open class Contributor: Codable {
    /** 所属店舗名 */
    public var affiliation: String?
    /** Profile ID */
    public var id: String?
    /** アイコンURL */
    public var imageUrl: String?
    /** 肩書 */
    public var jobTitle: String?
    /** 投稿者名 */
    public var name: String?

    public init(affiliation: String?, id: String?, imageUrl: String?, jobTitle: String?, name: String?) {
        self.affiliation = affiliation
        self.id = id
        self.imageUrl = imageUrl
        self.jobTitle = jobTitle
        self.name = name
    }

    // Encodable protocol methods
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(affiliation, forKey: "affiliation")
        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(imageUrl, forKey: "image_url")
        try container.encodeIfPresent(jobTitle, forKey: "job_title")
        try container.encodeIfPresent(name, forKey: "name")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        affiliation = try? container.decode(String.self, forKey: "affiliation")
        id = try? container.decode(String.self, forKey: "id")
        imageUrl = try? container.decode(String.self, forKey: "image_url")
        jobTitle = try? container.decode(String.self, forKey: "job_title")
        name = try? container.decode(String.self, forKey: "name")
    }
}

extension Contributor: Equatable {
    public static func == (lhs: Contributor, rhs: Contributor) -> Bool {
        return lhs.affiliation == rhs.affiliation && lhs.id == rhs.id && lhs.imageUrl == rhs.imageUrl && lhs.jobTitle == rhs.jobTitle && lhs.name == rhs.name
    }
}
