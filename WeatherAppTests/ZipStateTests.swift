import XCTest
@testable import WeatherApp

class ZipStateTests: XCTestCase {

    override func setUp() { }
    override func tearDown() { }

    func testValid() {
        let zipState = ZipCodeValidator.state(zipString: "90405")
        XCTAssertEqual(zipState, .valid(90405))
    }

    func testNil() {
        let zipState = ZipCodeValidator.state(zipString: nil)
        XCTAssertTrue(zipState == .noText)
    }

    func testTooFew() {
        let zipState = ZipCodeValidator.state(zipString: "9040")
        XCTAssertTrue(zipState == .tooFewNumbers)
    }

    func testTooMany() {
        let zipState = ZipCodeValidator.state(zipString: "904056")
        XCTAssertTrue(zipState == .tooManyNumbers)
    }

    func testInvalid() {
        let zipState = ZipCodeValidator.state(zipString: "90L05")
        XCTAssertTrue(zipState == .invalidCharacters)
    }

    func testInvalidAfterValid() {
        let zipState = ZipCodeValidator.state(zipString: "90405d")
        XCTAssertTrue(zipState == .invalidCharacters)
    }
}
