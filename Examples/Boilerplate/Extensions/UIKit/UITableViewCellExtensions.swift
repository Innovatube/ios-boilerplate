import Foundation
import UIKit

extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var enclosingTableView: UITableView? {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }

            return table as? UITableView
    }
}
