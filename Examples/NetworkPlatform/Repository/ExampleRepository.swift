import Domain
import RxSwift

final class ExampleRepository {
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func getData(limit: Int, offset: Int) -> Observable<[Any]> {
        return .empty()
    }
}
