import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class HomeReviewCountView: UIView, ReactiveType {
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    var contentView: UIView?

    var viewmodel: HomeReviewCountPresentable!
    let disposeBag = DisposeBag()

    var reviewCount: Int = 0 {
        didSet {
            lblReviewCount.text = "\(reviewCount)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        addSubview(view)
        contentView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor)
            ])
        if viewmodel == nil {
            viewmodel = HomeReviewCountViewModel()
        }

        bindViewModel()
    }

    func bindViewModel() {
        viewmodel.output.error
            .drive(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        viewmodel.output.count
            .map { $0.reviewCount }
            .drive(lblReviewCount.rx.text)
            .disposed(by: disposeBag)
        viewmodel.output.count
            .map { $0.likeCount }
            .drive(lblLikeCount.rx.text)
            .disposed(by: disposeBag)

        viewmodel.input.loadTrigger.onNext(())
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(resource: R.nib.homeReviewCountView)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
