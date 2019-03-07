import Foundation

struct AppSecrets: Codable {
    let openWeatherAppId: String
}

extension AppSecrets {
    static func load() -> AppSecrets {
        if let path = Bundle.main.path(forResource: "app", ofType: "secret") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                if let appSecrets = try? decoder.decode(AppSecrets.self, from: data) {
                    return appSecrets
                }
            } catch {
                preconditionFailure("Ensure the JSON in app.sercrets is consistent with AppSercrets. Error: \(error)")
            }
        }
        preconditionFailure("App assumes the existence of file in bundle: 'app.sercrets'.")
    }
}
