//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

struct GraphDataGenerator {
    
    private let breakdownService: BreakdownService
    
    init(breakdownService: BreakdownService) {
        self.breakdownService = breakdownService
    }
    
}

// MARK: - Logic

extension GraphDataGenerator {
    
    func breakdown(activity: PBActivity, records: [PRecordEntry]) -> ActivityBreakdown {
        var lines = getLines(activity: activity, records: records)
        lines = Self.finalise(data: lines)
        return ActivityBreakdown(lineVariants: lines)
    }
    
    private func getLines(activity: PBActivity, records: [PRecordEntry]) -> [String: [GraphLine]] {
        switch activity.trackingType {
        case .weightlifting:
            return repWeightBreakdown(records: records, activity: activity)
        default:
            return singleFieldBreakdown(type: activity.primaryMeasure, records: records, activity: activity)
        }
    }
    
    func singleFieldBreakdown(type: MeasurementType, records: [PRecordEntry], activity: PBActivity) -> [String: [GraphLine]] {
        let breakdown = breakdownService.singleBreakdown(type: type, records: records, activity: activity)
        var mapped: [String: [GraphLine]] = [:]
        for (key, value) in breakdown.values {
            let line = GraphLine(name: type.name, unit: .reps, entries: value, color: .blue)
            mapped[key] = [line]
        }
        return mapped
    }
    
    func repWeightBreakdown(records: [PRecordEntry], activity: PBActivity) -> [String: [GraphLine]] {
        let repResults = breakdownService.repWeightBreakdown(records: records, activity: activity)
        let unit = activity.currentUnit(.weight)
        
        var mapped: [String: [GraphLine]] = [:]
        
        repResults.repValues.forEach { (key, value) in
            let repLines: [GraphLine] = (1...BreakdownService.maxReps).compactMap { reps in
                guard let entries = value[reps] else { return nil }
                return GraphLine(name: "\(reps) Reps", unit: unit, entries: entries, color: color(index: reps))
            }
            mapped[key] = repLines
        }
        
        return mapped
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
    
    static func finalise(data: [String: [GraphLine]]) -> [String: [GraphLine]] {
        return data.mapValues { lines in
            return finalise(lines: lines)
        }
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
    
    func color(index: Int) -> Color {
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
