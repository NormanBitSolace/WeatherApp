import UIKit
import WebKit

final class AppNavigator: Navigator {

    func showWeather(model: WeatherModel, delegate: WeatherViewControllerDelegate) {
        DispatchQueue.main.async {
            let _: WeatherViewController = self.push(storyboardName: "Weather") { vc in
                vc.delegate = delegate
                vc.model = model
            }
        }
    }

    func showFavorites(anchor: Any, delegate: ZipViewControllerDelegate) {
        let _: MenuPopoverViewController = presentPopover(anchor: anchor) { vc in
            vc.data = ["90405", "95014", "93546", "95446", "9021o"]
            vc.popoverPresentationController?.permittedArrowDirections = .up
            vc.menuChoice = { choice in
                vc.dismiss(animated: true) {
                    delegate.zipCodeEntered(zipString: choice)
                }
            }
        }
    }

    func showEnterZipCode(delegate: ZipViewControllerDelegate & FavoritesMenuDelegate) {
        start(vc: ZipViewController.self, storyboardName: "Zip") { vc in
            vc.delegate = delegate
        }
    }

    func showZipCodeFormNoStoryboard(delegate: ZipViewControllerDelegate & FavoritesMenuDelegate) {
        start(vc: ZipViewController.self) { vc in
            vc.delegate = delegate
            ZipBuilder.build(vc)
        }
    }

    func alertUser(message: String) {
        DispatchQueue.main.async {
            self.singleButtonAlert(buttonLabel: "OK", title: message)
        }
    }

    func showLoading() -> UIViewController {
        let loadingVC: UIViewController = addChildViewController(storyboardName: "Loading") { vc in
            vc.view.frame = CGRect(x: 0, y: 0, width: 180, height: 180)
            vc.view.center = vc.parent!.view.center
        }
        return loadingVC
    }

    func hideLoading(_ vc: UIViewController) {
        DispatchQueue.main.async {
            self.removeChildViewController(childViewController: vc)
        }
    }
}

extension Navigator {   //  ALERT

    func singleButtonAlert(buttonLabel: String, title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonLabel, style: .default, handler: handler)
        alertController.addAction(okAction)
        rootNavigationController.present(alertController, animated: true, completion: nil)
    }
}
