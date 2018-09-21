import Foundation
import Domain
import Moya

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let networkProvider: NetworkProvider
    private let defaultNetwork: Network
    private let stubbNetwork: Network
    private let switchableNetwork: Network

    public init(networkProvider: NetworkProvider = NetworkProvider()) {
        self.networkProvider = networkProvider
        defaultNetwork = networkProvider.makeDefaultNetwork()
        stubbNetwork = networkProvider.makeStubbNetwork()
        #if DEBUG
        switchableNetwork = stubbNetwork
        #else
        switchableNetwork = defaultNetwork
        #endif
    }

    public func makeArticleUseCase() -> Domain.ArticleUseCase {
        return ArticleUseCase(repository: ArticleRepository(network: switchableNetwork))
    }

    public func makeReviewCountUseCase() -> Domain.ReviewCountUseCase {
        return ReviewCountUseCase(repository: ReviewCountRepository(network: switchableNetwork))
    }
}