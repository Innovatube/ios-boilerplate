public struct LikeReviewCount: Codable {
    public var likeCount: Int64?
    public var reviewCount: Int64?

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try? container.encodeIfPresent(likeCount, forKey: "like_count")
        try? container.encodeIfPresent(reviewCount, forKey: "review_count")
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        likeCount = try? container.decode(Int64.self, forKey: "like_count")
        reviewCount = try? container.decode(Int64.self, forKey: "review_count")
    }
}

extension LikeReviewCount: Equatable {
    public static func == (lhs: LikeReviewCount, rhs: LikeReviewCount) -> Bool {
        return lhs.likeCount == rhs.likeCount && lhs.reviewCount == rhs.reviewCount
    }
}
