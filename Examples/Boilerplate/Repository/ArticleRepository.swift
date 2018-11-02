import RxSwift

final class ArticleRepository {
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func getTopArticles(limit: Int, offset: Int) -> Observable<[Article]> {
        return network.provider.request(.homeTop(limit: limit, offset: offset))
            .map([Article].self, atKeyPath: "contents")
    }
}
