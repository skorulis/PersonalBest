//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

struct GraphLine: Identifiable {
    let name: String
    let unit: UnitType
    let entries: [EntryValue]
    let color: Color
    
    var id: String { name }
    
    func with(entries: [EntryValue]) -> GraphLine {
        return GraphLine(name: name, unit: unit, entries: entries, color: color)
    }
}

struct EntryValue: Identifiable {
    
    let date: Date
    let value: Decimal
    
    var id: Date { date }
    
    var dateString: String {
        return DateFormatter.mediumDate.string(from: date)
    }
    
}

struct ActivityBreakdown {
    
    let lines: [GraphLine]
    
    var canGraph: Bool {
        return lines.first(where: {$0.entries.count >= 2}) != nil
    }
    
    var hasData: Bool {
        return lines.first(where: {$0.entries.count >= 1}) != nil
    }
    
    var highestValue: TopRecord? {
        var best: TopRecord? = nil
        
        let items: [TopRecord] = lines.compactMap { line in
            guard let last = line.entries.last else {
                return nil
            }
            return TopRecord(date: last.date, value: last.value, unit: line.unit)
        }

        for value in items {
            guard let safeBest = best else {
                best = value
                continue
            }
            if value.value > safeBest.value {
                best = value
            }
        }
        return best
    }
    
}

enum BreakdownType {
    case reps, repsWeight
    
}

struct TopRecord: Identifiable {
    let date: Date
    let value: Decimal
    let unit: UnitType
    
    var id: Date { date }
}
