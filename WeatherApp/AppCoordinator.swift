import UIKit

final class AppCoordinator: NSObject {

    let navigator: AppNavigator
    let dataSource: DataSource

    init(appNavigator: AppNavigator, dataSource: DataSource) {
        self.navigator = appNavigator
        self.dataSource = dataSource
    }

    func start() {
        navigator.showEnterZipCode(delegate: self)
    }
}

extension AppCoordinator: ZipViewControllerDelegate {    // MARK: ZipViewControllerDelegate

    func zipCodeEntered(zipString: String?) {
        let result = ZipCodeValidator.state(zipString: zipString)
        switch result {
        case .noText, .tooFewNumbers, .tooManyNumbers, .invalidCharacters:
            navigator.alertUser(message: result.description)
        case .valid(let zipCode):
            fetchWeatherData(forZipCode: zipCode)
        }
    }

    func fetchWeatherData(forZipCode zipCode: Int) {
        let loadingVC = navigator.showLoading()
        dataSource.weather(forZipCode: zipCode) { [unowned self, weak nav = navigator] result in
            nav?.hideLoading(loadingVC)
            switch result {
            case .success(let model):
                // potentially transform to a view model(s)
                nav?.showWeather(model: model, delegate: self)
            case .failure(let message):
                nav?.alertUser(message: message.errorDescription)
            }
        }
    }
}

extension AppCoordinator: WeatherViewControllerDelegate {   // MARK: WeatherViewControllerDelegate

    func weatherIcon(name: String, completion: @escaping (UIImage) -> Void) {
        dataSource.weatherIcon(name: name) { image in
            DispatchQueue.main.async { completion(image) }
        }
    }
}

extension AppCoordinator: FavoritesMenuDelegate {

    func showFavorites(anchor: Any) {
        navigator.showFavorites(anchor: anchor, delegate: self)
    }

    func favoritePicked(_ zipString: String) {
        zipCodeEntered(zipString: zipString)
    }
}
