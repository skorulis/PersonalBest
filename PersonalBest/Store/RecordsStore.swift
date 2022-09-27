//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class RecordsStore: ObservableObject {
    
    @Published var records: [String: [ActivityEntry]]
    
    init() {
        records = [:]
    }
    
}

// MARK: - Logic

extension RecordsStore {
    
    func add(entry: ActivityEntry, activity: Activity) {
        guard var existing = records[activity.id] else {
            records[activity.id] = [entry]
            return
        }
        // TODO: Make sure this is sorted
        // TODO: Prevent duplicates
        // TODO: Should this only allow recrods which are ahead?
        existing.append(entry)
        records[activity.id] = existing
    }
    
}
