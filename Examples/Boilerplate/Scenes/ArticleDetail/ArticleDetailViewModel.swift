import RxSwift
import RxCocoa

struct ArticleDetailOutput {
    let loading: Driver<Bool>
    let error: Driver<Error>
    let article: Article
}

struct ArticleDetailInput {
    let loadTrigger: PublishSubject<Void>
}

protocol ArticleDetailPresentable {
    var input: ArticleDetailInput { get }
    var output: ArticleDetailOutput { get }
}

final class ArticleDetailViewModel: ArticleDetailPresentable {
    var input: ArticleDetailInput
    var output: ArticleDetailOutput

    private let disposeBag = DisposeBag()

    init(article: Article?) {
        let loading = ActivityIndicator()
        let error = ErrorTracker()

        input = ArticleDetailInput(loadTrigger: PublishSubject<Void>())

        let safeArticle: Article
        if let article = article {
            safeArticle = article
        } else {
            safeArticle = Article.dummyArticle()
        }
        output = ArticleDetailOutput(loading: loading.asDriver(), error: error.asDriver(), article: safeArticle)
    }
}
