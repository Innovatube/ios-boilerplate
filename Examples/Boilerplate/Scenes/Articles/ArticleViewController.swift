import UIKit
import RxSwift
import RxCocoa

class ArticleViewController: UITableViewController {
    @IBOutlet weak var reviewCountView: HomeReviewCountView!

    var viewModel: ArticlePresentable!
    internal let disposeBag = DisposeBag()

    lazy var articles: [Article] = []

    internal static func instantiate(viewModel: ArticlePresentable) -> ArticleViewController? {
        let vc = R.storyboard.article.articleViewController()
        vc?.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setUpTableView() {
        tableView.estimatedRowHeight = 91
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = nil
        tableView.delegate = nil
    }

    func bindViewModel() {
        let viewWillAppear = rx.viewWillAppear
            .mapToVoid()
            .take(1)
            .asDriverOnErrorJustComplete()

        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl

        let pull = refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()

        Driver.merge(viewWillAppear, pull)
            .drive(viewModel.input.loadTrigger)
            .disposed(by: disposeBag)

        tableView.rx.contentReachedBottom
            .bind(to: viewModel.input.loadNextTrigger)
            .disposed(by: disposeBag)

        viewModel.output.loading
            .filter { !$0 }
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.output.articles
            .drive(tableView.rx.items) { [weak self] tv, row, article in
                guard let weakSelf = self else { return UITableViewCell() }
                let ip = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: weakSelf.indentifier(row: row), for: ip)
                if let cell = cell as? BindableTableViewCell<Article> {
                    cell.bind(data: article)
                }
                return cell
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Article.self)
            .asDriver()
            .drive(onNext: { [weak self] in
                if let vc = ArticleDetailViewController.instantiate(viewModel: ArticleDetailViewModel(article: $0)) {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: disposeBag)

        viewModel.output.error
            .drive(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }

    func indentifier(row: Int) -> String {
        if row == 0 {
            return R.reuseIdentifier.homeTopHeaderCell.identifier
        }
        return R.reuseIdentifier.homeTopContentCell.identifier
    }
}
