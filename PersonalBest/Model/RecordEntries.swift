//Created by Alexander Skorulis on 28/9/2022.

import Foundation
import SwiftUI

struct RecordEntries: Identifiable {
    let name: String
    let entries: [EntryValue]
    let color: Color
    
    var id: String { name }
}

struct EntryValue: Identifiable {
    
    let date: Date
    let value: Decimal
    
    var id: Date { date }
    
}

enum BreakdownType {
    case reps, repsWeight
    
}

// MARK: - Logic

extension RecordEntries {
    
    static func breakdown(type: BreakdownType, records: [ActivityEntry]) -> [RecordEntries] {
        switch type {
        case .reps: return [reps(records: records)]
        case .repsWeight: return repWeightBreakdown(records: records)
        }
    }
    
    static func reps(records: [ActivityEntry]) -> RecordEntries {
        var topValue: Decimal = -1
        var result: [EntryValue] = []
        records.forEach { entry in
            if let value = entry.values[.reps], value > topValue {
                topValue = value
                let entryValue = EntryValue(date: entry.date, value: value)
                result.append(entryValue)
            }
        }
        
        return RecordEntries(name: "Reps", entries: result, color: .blue)
    }
    
    static func repWeightBreakdown(records: [ActivityEntry]) -> [RecordEntries] {
        let maxReps = 5
        var repResults = [Int: [EntryValue]]()
        
        records.forEach { entry in
            if let reps = entry.values[.reps], let weight = entry.values[.weight] {
                let repInt = (reps as NSDecimalNumber).intValue
                var array = repResults[repInt] ?? []
                let top = array.last?.value ?? -1
                if weight > top {
                    let entryValue = EntryValue(date: entry.date, value: weight)
                    array.append(entryValue)
                    repResults[repInt] = array
                }
            }
        }
        
        return (1...maxReps).compactMap { reps in
            guard let entries = repResults[reps] else { return nil }
            return RecordEntries(name: "\(reps) Reps", entries: entries, color: color(index: reps))
        }
        
    }
    
    static func finalise(entries: [RecordEntries]) -> [RecordEntries] {
        var maxDate = entries.compactMap { $0.entries.last?.date }.max() ?? Date()
        maxDate = max(maxDate, Date())
        return entries.map { re in
            guard let last = re.entries.last, last.date < maxDate else {
                return re
            }
            let placeholder = EntryValue(date: maxDate, value: last.value)
            var array = re.entries
            array.append(placeholder)
            
            return RecordEntries(name: re.name, entries: array, color: re.color)
        }
    }
    
    static func color(index: Int) -> Color {
        switch index {
        case 1: return .blue
        case 2: return .red
        case 3: return .green
        case 4: return .orange
        case 5: return .purple
        case 6: return .cyan
        case 7: return .brown
        default: return .black
        }
    }
    
}
