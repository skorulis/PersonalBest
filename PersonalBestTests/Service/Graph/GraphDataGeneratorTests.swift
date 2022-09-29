//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import XCTest
@testable import PersonalBest

final class GraphDataGeneratorTests: XCTestCase {
    
    private let ioc = IOC()
    private lazy var recordsStore = ioc.resolve(RecordsStore.self)
    private lazy var sut = ioc.resolve(GraphDataGenerator.self)
    
    func test_repsAndWeight() {
        let day: TimeInterval = 86400
        let activity = Activity(systemName: "Bench press", tracking: .weightlifting)
        recordsStore.add(entry: .init(date: Date().advanced(by: -6 * day), values: [.reps: 1, .weight: 10]), activity: activity)
        recordsStore.add(entry: .init(date: Date().advanced(by: -4 * day), values: [.reps: 1, .weight: 15]), activity: activity)
        recordsStore.add(entry: .init(date: Date().advanced(by: -2 * day), values: [.reps: 1, .weight: 15]), activity: activity)
        recordsStore.add(entry: .init(date: Date(), values: [.reps: 1, .weight: 20]), activity: activity)
        
        recordsStore.add(entry: .init(date: Date().advanced(by: -4 * day), values: [.reps: 5, .weight: 5]), activity: activity)
        recordsStore.add(entry: .init(date: Date().advanced(by: -2 * day), values: [.reps: 5, .weight: 10]), activity: activity)
        recordsStore.add(entry: .init(date: Date(), values: [.reps: 5, .weight: 15]), activity: activity)
        
        
        let data = sut.breakdown(activity: activity).lines
        XCTAssertEqual(data.count, 2)
        
        let rep1 = data[0]
        XCTAssertEqual(rep1.name, "1 Reps")
        XCTAssertEqual(rep1.entries.count, 3)
        
        let rep5 = data[1]
        XCTAssertEqual(rep5.name, "5 Reps")
        XCTAssertEqual(rep5.entries.count, 3)
        
        
    }
    
    
}

