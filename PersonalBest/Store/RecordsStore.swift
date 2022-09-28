//Created by Alexander Skorulis on 27/9/2022.

import ASKCore
import Foundation

// MARK: - Memory footprint

final class RecordsStore: ObservableObject {
    
    private static let storageKey = "RecordsStore.records"
    private let keyValueStore: PKeyValueStore
    
    @Published var records: [String: [ActivityEntry]] {
        didSet {
            try! keyValueStore.set(codable: records, forKey: Self.storageKey)
        }
    }
    
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        records = Self.readFromDisk(store: keyValueStore)
    }
    
}

// MARK: - Logic

extension RecordsStore {
    
    func add(entry: ActivityEntry, activity: Activity) {
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
