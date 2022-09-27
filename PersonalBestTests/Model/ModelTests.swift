//Created by Alexander Skorulis on 26/9/2022.

import Foundation
import XCTest
@testable import PersonalBest

final class ModelTests: XCTestCase {

    func test_unitParsing() throws {
        let unit = ActivityUnit.custom(.init(name: "Kilometers", abbreviation: "Km"))
        let json = try JSONEncoder().encode(unit)
        let jsonString = String(data: json, encoding: .utf8)
        
        let decoded = try JSONDecoder().decode(ActivityUnit.self, from: json)
        XCTAssertEqual(decoded.name, "Kilometers")
        XCTAssertEqual(decoded.abbreviation, "Km")
    }

}
