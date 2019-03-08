import UIKit

protocol ZipViewControllerDelegate: class {
    func zipCodeEntered(zipString: String?)
}

protocol FavoritesMenuDelegate: class {
    func showFavorites(anchor: Any)
}

final class ZipViewController: UIViewController {

    weak var delegate: (ZipViewControllerDelegate & FavoritesMenuDelegate)?
    @IBOutlet weak var textField: UITextField!

    @IBAction func weatherTap() {
        guard let delegate = delegate else { preconditionFailure("App assumes delegate is set.") }
        /*
         check if textField.text is nil
         check if textField.text.count is 0
         check if textField.text is numeric
         check if too few numbers
         check if too many numbers
         else valid zip code
         */
        delegate.zipCodeEntered(zipString: textField.text)
    }
    @IBAction func favoritesTap(_ sender: Any) {
        guard let delegate = delegate else { preconditionFailure("App assumes delegate is set.") }
        textField.resignFirstResponder()
        delegate.showFavorites(anchor: sender)
    }
}
