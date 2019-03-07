import UIKit

struct OpenWeatherApi: DataSource {
    private var appId = AppSecrets.load().openWeatherAppId
    private let weatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"

    func weatherIcon(name: String, completion: @escaping (UIImage) -> Void) {
        let urlString = "https://openweathermap.org/img/w/\(name).png"
        guard let url = URL(string: urlString) else { preconditionFailure("App expects this to be a valid URL.")}
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                return completion(image)
            }
        }
    }

    func weather(forZipCode zipCode: Int, completion: @escaping WeatherHandler) {
        guard let url = URL(string: "\(weatherBaseUrl)?zip=\(zipCode),us&APPID=\(appId)") else {
            preconditionFailure("App assumes this is a valid URL.")
        }
        var req = URLRequest(url: url)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.timeoutInterval = 4
        let dataTask = URLSession.shared.dataTask(with: req) { data, _, err in
            guard err == nil else { return completion(.failure(.runTimeError(err?.localizedDescription))) }
            guard let jsonData = data else { return completion(.failure(.invalidConnection)) }
            do {
                let decoder = JSONDecoder()
                // print(jsonData.asString)
                let resource = try decoder.decode(OpenWeatherModel.self, from: jsonData)
                if let weatherModel = WeatherModel(from: resource) {
                    return completion(.success(weatherModel))
                }
                // Lame logic but backend returns result as an Int when successful, and as a String when zip isn't valid
                return completion(.failure(.noSuchCity))
            } catch {
                return completion(.failure(.invalidObject(error.localizedDescription)))
            }
        }
        dataTask.resume()
    }
}

extension Data {
    var asString: String { return String(decoding: self, as: UTF8.self) }
}

private struct OpenWeatherModel: Codable {
    struct OWWeather: Codable {
        let main: String
        let icon: String
    }
    struct OWTemperature: Codable {
        let temp: Float
    }
    let weather: [OWWeather]?
    let main: OWTemperature?
    let name: String?
}

private extension WeatherModel {
    init?(from model: OpenWeatherModel) {
        if let main = model.main,
            let name = model.name,
            let openWeatherModel = model.weather?.first {
            let celcius = main.temp - 273.15
            temperature = Int((celcius * 9.0) / 5.0) + 32
            city = name
            condition = openWeatherModel.main
            iconName = openWeatherModel.icon
        } else {
            return nil
        }
    }
}
