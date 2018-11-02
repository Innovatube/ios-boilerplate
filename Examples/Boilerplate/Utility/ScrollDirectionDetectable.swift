import RxSwift

protocol ScrollDirectionDetectable: ReactiveType {
    var scrollViewForObserver: UIScrollView? { get }
    var isScrollingDown: PublishSubject<Bool> { get }
}

extension ScrollDirectionDetectable where Self: UIViewController {
    func setUpDirectionObserver() {
        guard let scrollView = scrollViewForObserver else { return }
        scrollView.rx.didScroll
            .asDriver()
            .map { [weak scrollView] in
                guard let weakScrollView = scrollView else { return CGFloat(0) }
                return weakScrollView.panGestureRecognizer.velocity(in: weakScrollView.superview).y
            }
            .filter { $0 != CGFloat(0) }
            .map { $0 < CGFloat(0) }
            .drive(isScrollingDown)
            .disposed(by: disposeBag)
    }
}
