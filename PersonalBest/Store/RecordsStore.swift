//Created by Alexander Skorulis on 27/9/2022.

import ASKCore
import Foundation

// MARK: - Memory footprint

final class RecordsStore: ObservableObject {
    
    init() {}
    
}

/*

// MARK: - Logic

extension RecordsStore {
    
    func add(entry: ActivityEntry, activity: PBActivity) {
        guard var existing = records[activity.id] else {
            records[activity.id] = [entry]
            return
        }
        for i in (0..<existing.count).reversed() {
            if existing[i].date <= entry.date {
                existing.insert(entry, at: i + 1)
                break
            } else if i == 0 {
                existing.insert(entry, at: 0)
            }
        }
        // TODO: Prevent duplicates?
        records[activity.id] = existing
    }
    
    func delete(entry: ActivityEntry, activity: PBActivity) {
        guard var existing = records[activity.id] else {
            return
        }
        existing = existing.filter { $0.id != entry.id }
        if existing.count == 0 {
            records.removeValue(forKey: activity.id)
        } else {
            records[activity.id] = existing
        }
    }
    
    func topValue(activity: Activity, type: MeasurementType) -> TopRecord? {
        guard let existing = records[activity.id] else {
            return nil
        }
        var best: TopRecord?
        for entry in existing {
            guard let value = entry.values[type] else {
                continue
            }
            guard let safeBest = best else {
                best = TopRecord(date: entry.date, value: value, unit: type.defaultUnit)
                continue
            }
            // TODO: Handle backwards types
            if value > safeBest.value {
                best = TopRecord(date: entry.date, value: value, unit: type.defaultUnit)
            }
        }
        
        return best
    }
    
}

// MARK: - Logic (private)

private extension RecordsStore {
    
    static func readFromDisk(store: PKeyValueStore) -> [String: [ActivityEntry]] {
        if let fromDisk: [String: [ActivityEntry]] = try? store.codable(forKey: Self.storageKey) {
            return fromDisk
        }
        return [:]
    }
}
*/
