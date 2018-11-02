import RxSwift
import RxCocoa
import RxSwiftExt
import Moya

class PaginationSource<T: Equatable> {
    typealias PaginationRequest = (_ limit: Int, _ offset: Int) -> Observable<[T]>

    // Input
    private let limit: Int
    private let page = PublishSubject<(limit: Int, offset: Int)>()
    private let loading = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    private let elementSource = PublishSubject<[T]>()
    let refreshTrigger: PublishSubject<Void> = PublishSubject()
    let loadNextTrigger: PublishSubject<Void> = PublishSubject()
    lazy var elements = self.elementSource.asObservable()
    lazy var isLoading = self.loading.asDriver()
    lazy var error = self.errorTracker.asDriver()

    // Private
    private let request: PaginationRequest

    private lazy var requestElements: Observable<[T]> = {
        return page.flatMapLatest { page in
            self.request(page.0, page.1)
                .trackActivity(self.loading)
                .trackError(self.errorTracker)
                .materialize()
                .elements()
            }.share(replay: 1)
    }()

    private let disposeBag = DisposeBag()

    // Init
    init(request: @escaping PaginationRequest, limit: Int = 20) {
        self.request = request
        self.limit = limit

        isLoading.asObservable()
            .sample(refreshTrigger)
            .filter { !$0 }
            .map { _ in
                return (limit, 0)
            }
            .bind(to: page)
            .disposed(by: disposeBag)

        let notFoundError = PublishSubject<Bool>()
        refreshTrigger.map { _ in false }
            .bind(to: notFoundError)
            .disposed(by: disposeBag)
        error.map { error -> Bool in
            if case MoyaError.underlying(_, let response) = error {
                return response?.statusCode == 404
            }
            return false
            }.drive(notFoundError)
            .disposed(by: disposeBag)

        let currentPage = Observable.combineLatest(notFoundError.asObservable(), isLoading.asObservable(), requestElements, page.asObserver())

        currentPage
            .sample(loadNextTrigger)
            .filter { !$0.0 && !$0.1 && $0.2.isNotEmpty }
            .map { ($0.3.limit, $0.3.offset + limit) }
            .bind(to: page)
            .disposed(by: disposeBag)

        page
            .filter { $0.1 == 0 }
            .map { _ in [] }
            .skip(1)
            .bind(to: elementSource)
            .disposed(by: disposeBag)

        requestElements
            .withLatestFrom(elements.startWith([])) {
                $1 + $0
            }
            .bind(to: elementSource)
            .disposed(by: disposeBag)
    }
}
