import RxSwift

final class ReviewCountRepository {
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func getCount() -> Observable<LikeReviewCount> {
        return network.provider.request(.homeHeaders)
            .map(LikeReviewCount.self)
    }
}
