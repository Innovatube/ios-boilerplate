import UIKit

extension UIViewController {
    func setNavigationBarBackItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = R.image.icon_back_navi()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = R.image.icon_back_navi()
    }

    func changeNavigationBarShadowImage(_ image: UIImage?) {
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
