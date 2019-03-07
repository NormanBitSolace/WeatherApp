import UIKit

enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}

enum WeatherErrorType: Error {
    case invalidObject(String?)
    case invalidConnection
    case noSuchCity
    case runTimeError(String?)

    var errorDescription: String {
        switch self {
        case .invalidObject(let message):
            return "Data issue: '\(message ?? "Unspecified error")'"
        case .invalidConnection:
            return "Internet connection issue"
        case .noSuchCity:
            return "The zip code isn't valid"
        case .runTimeError(let message):
            return message ?? "Unspecified error"
        }
    }
}

typealias WeatherHandler = (Result<WeatherModel, WeatherErrorType>) -> Void

protocol DataSource {
    func weather(forZipCode zipCode: Int, completion: @escaping WeatherHandler)
    func weatherIcon(name: String, completion: @escaping (UIImage) -> Void)
}
