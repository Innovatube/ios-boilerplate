import Foundation

#if canImport(RxSwift)
import RxSwift

/*
 thanks to: https://github.com/ReactiveX/RxSwift/issues/821#issuecomment-301429488
 */

private var prepareForReuseBag: Int8 = 0

extension Reactive where Base: UITableViewCell {
    var prepareForReuse: Observable<Void> {
        return Observable.of(sentMessage(#selector(UITableViewCell.prepareForReuse)).map { _ in () }, deallocated).merge()
    }

    var disposeBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()

        if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
            return bag
        }

        let bag = DisposeBag()
        objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)

        _ = sentMessage(#selector(UITableViewCell.prepareForReuse))
            .subscribe(onNext: { [weak base] _ in
                assert(base != nil)
                guard let weakSelf = base else { return }
                let newBag = DisposeBag()
                objc_setAssociatedObject(weakSelf, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })

        return bag
    }
}

#endif
