import Moya
public final class NetworkProvider {

    public init() {
    }

    public func makeDefaultNetwork() -> Network {
        return Network()
    }

    public func makeStubbNetwork() -> Network {
        return Network(provider: APIProvider(stubClosure: MoyaProvider.delayedStub(1)))
    }
}
