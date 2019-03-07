import UIKit

protocol WeatherViewControllerDelegate: class {
    func weatherIcon(name: String, completion: @escaping (UIImage) -> Void)
}

final class WeatherViewController: UIViewController {

    weak var delegate: WeatherViewControllerDelegate?
    final var model: WeatherModel? {
        didSet {
            update()
        }
    }

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!

    final func update() {
        guard let model = model else { preconditionFailure("App assumes model is set when using this view controller.")}
        cityLabel.text = model.city
        temperatureLabel.text = "\(model.temperature)°"
        conditionLabel.text = model.condition
        delegate?.weatherIcon(name: model.iconName) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
