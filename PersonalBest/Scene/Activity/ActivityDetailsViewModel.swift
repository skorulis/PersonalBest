//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    let activity: Activity
    private let recordsStore: RecordsStore
    
    @Published var recordBreakdown: [RecordEntries] = []
    
    init(activity: Activity,
         recordsStore: RecordsStore
    ) {
        self.activity = activity
        self.recordsStore = recordsStore
        super.init()
        self.recordBreakdown = self.breakdown()
        
        recordsStore.objectWillChange
            .delayedChange()
            .sink { [unowned self] _ in
                self.recordBreakdown = self.breakdown()
            }
            .store(in: &subscribers)
    }
    
}

// MARK: - Computed values

extension ActivityDetailsViewModel {
    
    var records: [ActivityEntry] {
        return recordsStore.records[activity.id] ?? []
    }
    
    // Return only values going upwards
    var ascendingValues: [ActivityEntry] {
        var topValue: Decimal = -1
        var result: [ActivityEntry] = []
        records.forEach { entry in
            if let value = entry.values[.reps] {
                if value > topValue {
                    topValue = value
                    result.append(entry)
                }
            }
        }
        
        return result
    }
    
    var linePoints: [(Date, Decimal)] {
        return records.map { entry in
            return (entry.date, entry.values[.reps] ?? 0)
        }
    }
    
}

// MARK: - Logic

extension ActivityDetailsViewModel {
    
    func breakdown() -> [RecordEntries] {
        let type = activity.breakdownType
        let entries = RecordEntries.breakdown(type: type, records: self.records)
        return RecordEntries.finalise(entries: entries)
    }
    
    func addEntry() {
        let path = RootPath.addEntry(activity)
        coordinator.present(path, style: .sheet)
    }
    
}
