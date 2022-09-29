//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    let activity: Activity
    private let recordsStore: RecordsStore
    private let graphGenerator: GraphDataGenerator
    
    @Published var recordBreakdown: ActivityBreakdown
    @Published var displayType: DisplayType = .chart
    
    init(activity: Activity,
         recordsStore: RecordsStore,
         graphGenerator: GraphDataGenerator
    ) {
        self.activity = activity
        self.recordsStore = recordsStore
        self.graphGenerator = graphGenerator
        self.recordBreakdown = self.graphGenerator.breakdown(activity: self.activity)
        super.init()
        if !self.recordBreakdown.canGraph {
            self.displayType = .list
        }
        
        recordsStore.objectWillChange
            .delayedChange()
            .sink { [unowned self] _ in
                self.recordBreakdown = self.graphGenerator.breakdown(activity: self.activity)
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
    
    func addEntry() {
        let path = RootPath.addEntry(activity)
        coordinator.present(path, style: .sheet)
    }
    
    func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            let entry = self.records[index]
            self.recordsStore.delete(entry: entry, activity: self.activity)
        }
        
    }
    
}

// MARK: - Inner types

extension ActivityDetailsViewModel {
    
    enum DisplayType {
        case list
        case chart
    }
    
}
