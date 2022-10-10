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
    let value: Double
    
    var id: Date { date }
    
    var dateString: String {
        return DateFormatter.mediumDate.string(from: date)
    }
    
}

struct ActivityBreakdown {
    
    let lineVariants: [String: [GraphLine]]
    
    var variants: [String] {
        return Array(lineVariants.keys)
    }
    
    var canGraph: Bool {
        return lineVariants.contains { (key, lines) in
            return lines.first(where: {$0.entries.count >= 2}) != nil
        }
    }
    
    var hasData: Bool {
        return lineVariants.contains { (key, lines) in
            return lines.first(where: {$0.entries.count >= 1}) != nil
        }
    }
    
    func highestValue(variant: String) -> TopRecord? {
        var best: TopRecord? = nil
        guard let lines = lineVariants[variant] else { return nil }
        
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
    let value: Double
    let unit: UnitType
    
    var id: Date { date }
}
