//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

struct GraphDataGenerator {
    
    let recordsStore: RecordsStore
    
    init(recordsStore: RecordsStore) {
        self.recordsStore = recordsStore
    }
    
}

// MARK: - Logic

extension GraphDataGenerator {
    
    func breakdown(activity: PBActivity) -> ActivityBreakdown {
        let records = Array(activity.records)
        
        var lines = Self.getLines(activity: activity, records: records)
        lines = Self.finalise(lines: lines)
        return ActivityBreakdown(lines: lines)
    }
    
    private static func getLines(activity: PBActivity, records: [PBRecordEntry]) -> [GraphLine] {
        switch activity.trackingType {
        case .weightlifting:
            return repWeightBreakdown(records: records, unit: .kilograms)
        default:
            return [reps(records: records)]
        }
    }
    
    static func reps(records: [PBRecordEntry]) -> GraphLine {
        var topValue: Decimal = -1
        var result: [EntryValue] = []
        records.forEach { entry in
            let values = entry.entryValues
            if let value = values[.reps], value > topValue {
                topValue = value
                let entryValue = EntryValue(date: entry.date, value: value)
                result.append(entryValue)
            }
        }
        
        return GraphLine(name: "Reps", unit: .reps, entries: result, color: .blue)
    }
    
    static func repWeightBreakdown(records: [PBRecordEntry], unit: UnitType) -> [GraphLine] {
        let maxReps = 5
        var repResults = [Int: [EntryValue]]()
        
        records.forEach { entry in
            let values = entry.entryValues
            if let reps = values[.reps], let weight = values[.weight] {
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
            return GraphLine(name: "\(reps) Reps", unit: unit, entries: entries, color: color(index: reps))
        }
        
    }
    
    static func alignToDays(line: GraphLine) -> GraphLine {
        let calendar = Calendar.current
        var entries = line.entries.map { ev in
            return EntryValue(date: calendar.startOfDay(for: ev.date), value: ev.value)
        }
        
        if entries.count >= 2 {
            for i in (0..<entries.count - 1).reversed() {
                if entries[i].date == entries[i+1].date {
                    entries.remove(at: i)
                }
            }
        }
        
        return line.with(entries: entries)
    }
    
    static func appendMax(line: GraphLine, maxDate: Date) -> GraphLine {
        guard let last = line.entries.last, last.date < maxDate else {
            return line
        }
        let placeholder = EntryValue(date: maxDate, value: last.value)
        var array = line.entries
        array.append(placeholder)
        
        return line.with(entries: array)
    }
    
    static func finalise(lines: [GraphLine]) -> [GraphLine] {
        let result = lines.map { alignToDays(line: $0) }
        
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        var maxDate = result.compactMap { $0.entries.last?.date }.max() ?? todayStart
        maxDate = max(maxDate, todayStart)
        
        return result.map { line in
            return appendMax(line: line, maxDate: maxDate)
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
