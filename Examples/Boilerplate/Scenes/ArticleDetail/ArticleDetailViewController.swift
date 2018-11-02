import UIKit
import RxSwift
import RxCocoa

class ArticleDetailViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    var viewModel: ArticleDetailPresentable!
    internal let disposeBag = DisposeBag()

    internal static func instantiate(viewModel: ArticleDetailPresentable) -> ArticleDetailViewController? {
        let vc = R.storyboard.articleDetail.articleDetailViewController()
        vc?.viewModel = viewModel

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil, "View model must not be nil")

        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bindViewModel() {
        let viewWillAppear = rx.viewWillAppear
            .mapToVoid()
            .take(1)
            .asDriverOnErrorJustComplete()
        viewWillAppear.drive(viewModel.input.loadTrigger).disposed(by: disposeBag)

        viewModel.output.error.drive(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        let article = viewModel.output.article
        title = article.title

        var url = URL(string: "https://www.cosme.net/a-beauty/article/I0011712")
        if let urlString = article.url, let realUrl = URL(string: urlString) {
            url = realUrl
        }
        if let safeUrl = url {
            webView.loadRequest(URLRequest(url: safeUrl))
        }
    }
}
