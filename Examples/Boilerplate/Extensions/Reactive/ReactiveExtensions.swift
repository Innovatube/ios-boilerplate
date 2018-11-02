import RxSwift
import RxCocoa
import UIKit
import RxOptional

infix operator <-> : DefaultPrecedence

func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument

    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }

    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }

    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }

    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

func <-> <Base>(textInput: TextInput<Base>, variable: Variable<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: textInput.text)
    let bindToVariable = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] _ in
            guard let base = base else {
                return
            }

            let nonMarkedTextValue = nonMarkedText(base)

            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
                variable.value = nonMarkedTextValue
            }
            }, onCompleted: {
                bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    if T.self == String.self {
        #if DEBUG
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to variable.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> variable` instead of `textField.rx.text <-> variable`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
        )
        #endif
    }

    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.value = n
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}

extension Reactive where Base: UIScrollView {
    public var contentReachedBottom: Observable<Void> {
        let scrollView = self.base as UIScrollView
        let contentSizeNotFit = self.observe(CGSize.self, "contentSize")
            .filterNil()
            .map { $0.height }
            .filter { [weak scrollView] in
                guard let scrollView = scrollView else { return false }
                let headerHeight = (scrollView as? UITableView)?.tableHeaderView?.height ?? 0
                return $0 > headerHeight && $0 < (scrollView.height - scrollView.contentInset.top - scrollView.contentInset.bottom)
            }.mapToVoid()
        let reachBottom = self.contentOffset.flatMap { [weak scrollView] (contentOffset) -> Observable<Void> in
            guard let scrollView = scrollView else { return Observable.empty() }
            let visibleHeight = scrollView.frame.height - self.base.contentInset.top - scrollView.contentInset.bottom
            let y = contentOffset.y + scrollView.contentInset.top
            let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
            return (y > threshold - (threshold / 4)) ? Observable.just(()) : Observable.empty()
        }
        return Observable.merge(contentSizeNotFit, reachBottom)
    }
}
