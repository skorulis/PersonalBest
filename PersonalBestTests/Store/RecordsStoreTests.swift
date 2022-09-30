//Created by Alexander Skorulis on 28/9/2022.

import Foundation
import XCTest
@testable import PersonalBest

final class RecordsStoreTests: XCTestCase {

    private let ioc = IOC()
    private lazy var sut = ioc.resolve(RecordsStore.self)
    
    func test_ordering() throws {
        let activity = Activity(systemName: "Test", singleMeasure: .reps)
        
        let d1 = Date(timeIntervalSince1970: 100000)
        let d2 = Date(timeIntervalSince1970: 1000000)
        let d3 = Date(timeIntervalSince1970: 10000000)
        
        sut.add(entry: .init(date: d2, values: [:]), activity: activity)
        XCTAssertEqual(sut.records[activity.id]!.count, 1)
        sut.add(entry: .init(date: d1, values: [:]), activity: activity)
        XCTAssertEqual(sut.records[activity.id]!.count, 2)
        sut.add(entry: .init(date: d3, values: [:]), activity: activity)
        
        let records = sut.records[activity.id]!
        
        XCTAssertEqual(records.count, 3)
        XCTAssertEqual(records[0].date, d1)
        XCTAssertEqual(records[1].date, d2)
        XCTAssertEqual(records[2].date, d3)
        
    }

}


