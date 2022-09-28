//Created by Alexander Skorulis on 28/9/2022.

import Foundation
import XCTest
@testable import PersonalBest

final class RecordEntriesTests: XCTestCase {
    
    func test_repsAndWeight() {
        let entries: [ActivityEntry] = [
            .init(date: Date(), values: [.reps: 1, .weight: 10]),
            .init(date: Date(), values: [.reps: 1, .weight: 15]),
            .init(date: Date(), values: [.reps: 1, .weight: 15]),
            .init(date: Date(), values: [.reps: 1, .weight: 20]),
            
            .init(date: Date(), values: [.reps: 5, .weight: 5]),
            .init(date: Date(), values: [.reps: 5, .weight: 10]),
            .init(date: Date(), values: [.reps: 5, .weight: 15])
        ]
        
        let data = RecordEntries.repWeightBreakdown(records: entries)
        XCTAssertEqual(data.count, 2)
        
        let rep1 = data[0]
        XCTAssertEqual(rep1.name, "1 Reps")
        XCTAssertEqual(rep1.entries.count, 3)
        
        let rep5 = data[1]
        XCTAssertEqual(rep5.name, "5 Reps")
        XCTAssertEqual(rep5.entries.count, 3)
        
        
    }
    
    
}
