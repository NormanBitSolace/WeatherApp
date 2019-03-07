import Foundation

enum ZipCodeValidator: Equatable, CustomStringConvertible {

    case noText, tooFewNumbers, tooManyNumbers, invalidCharacters
    case valid(Int)

    var description: String {
        switch self {
        case .noText:
            return "Use the keypad to enter text"
        case .tooFewNumbers:
            return "Zip code requires 5 numbers"
        case .tooManyNumbers:
            return "Zip code can only have 5 numbers"
        case .invalidCharacters:
            return "Zip code can only contain numeric values"
        case .valid(let zipCode):
            return "\(zipCode) is a valid zipcode"
        }
    }

    static func state(zipString: String?) -> ZipCodeValidator {
        guard let text = zipString else { return .noText }
        guard text.count != 0 else { return .noText }
        guard let zipCode = Int(text) else { return .invalidCharacters }
        guard text.count == 5 else {
            if text.count < 5 { return .tooFewNumbers } else { return .tooManyNumbers }
        }
        return .valid(zipCode)
    }
}
