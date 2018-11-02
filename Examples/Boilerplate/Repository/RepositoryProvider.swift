final class RepositoryProvider {
    private let networkProvider: NetworkProvider
    private let defaultNetwork: Network
    private let stubbNetwork: Network
    private let switchableNetwork: Network

    init(networkProvider: NetworkProvider = NetworkProvider()) {
        self.networkProvider = networkProvider
        defaultNetwork = networkProvider.makeDefaultNetwork()
        stubbNetwork = networkProvider.makeStubbNetwork()
        #if DEBUG
        switchableNetwork = stubbNetwork
        #else
        switchableNetwork = defaultNetwork
        #endif
    }

    func makeArticleRepository() -> ArticleRepository {
        return ArticleRepository(network: switchableNetwork)
    }

    func makeReviewCountRepository() -> ReviewCountRepository {
        return ReviewCountRepository(network: switchableNetwork)
    }
}
