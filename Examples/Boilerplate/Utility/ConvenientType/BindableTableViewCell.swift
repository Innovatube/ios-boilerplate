import UIKit

class BindableTableViewCell<E>: UITableViewCell, CellBindableType {
    typealias T = E

    func bind(data: E) {}
}
