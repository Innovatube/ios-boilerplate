import UIKit
import RxSwift
import RxCocoa

struct ArticleInput {
    let loadTrigger: PublishSubject<Void>
    let loadNextTrigger: PublishSubject<Void>
}

struct ArticleOutput {
    let articles: Driver<[Article]>
    let loading: Driver<Bool>
    let error: Driver<Error>
}

protocol ArticlePresentable {
    var input: ArticleInput { get }
    var output: ArticleOutput { get }
}

final class ArticleViewModel: ArticlePresentable {
    var input: ArticleInput
    var output: ArticleOutput
    var repo: ArticleRepository

    private let disposeBag = DisposeBag()

    init(repo: ArticleRepository = RepositoryProvider().makeArticleRepository()) {
        self.repo = repo
        self.input = ArticleInput(loadTrigger: PublishSubject<Void>(), loadNextTrigger: PublishSubject<Void>())

        let articlesRequest: (_ limit: Int, _ offset: Int) -> Observable<[Article]> = { limit, offset in
            return repo.getTopArticles(limit: limit, offset: offset)
        }
        let paginationSource = PaginationSource(request: articlesRequest)
        self.input.loadTrigger
            .bind(to: paginationSource.refreshTrigger)
            .disposed(by: disposeBag)
        self.input.loadNextTrigger
            .bind(to: paginationSource.loadNextTrigger)
            .disposed(by: disposeBag)
        let articles = paginationSource.elements
            .asDriverOnErrorJustComplete()
        let loading = paginationSource.isLoading
        let error = paginationSource.error
        self.output = ArticleOutput(articles: articles, loading: loading, error: error)
    }
}
