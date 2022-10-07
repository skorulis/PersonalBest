//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    let activity: PBActivity
    private let recordsStore: RecordsStore
    private let graphGenerator: GraphDataGenerator
    private let coreDataStore: CoreDataStore
    
    @Published var recordBreakdown: ActivityBreakdown
    @Published var displayType: DisplayType = .chart
    @Published var variant: String = PBVariant.none
    
    init(activity: PBActivity,
         recordsStore: RecordsStore,
         graphGenerator: GraphDataGenerator,
         coreDataStore: CoreDataStore
    ) {
        self.activity = activity
        self.recordsStore = recordsStore
        self.graphGenerator = graphGenerator
        self.coreDataStore = coreDataStore
        self.recordBreakdown = self.graphGenerator.breakdown(activity: self.activity, records: activity.orderedRecords)
        super.init()
        if !self.recordBreakdown.canGraph {
            self.displayType = .list
        }
        
        activity.objectWillChange
            .delayedChange()
            .sink { [unowned self] _ in
                self.recordBreakdown = self.graphGenerator.breakdown(activity: self.activity, records: activity.orderedRecords)
            }
            .store(in: &subscribers)
    }
    
}

// MARK: - Computed values

extension ActivityDetailsViewModel {
 
    var lines: [GraphLine]? {
        return recordBreakdown.lineVariants[variant]
    }
    
}

// MARK: - Logic

extension ActivityDetailsViewModel {
    
    func addEntry() {
        let initialVariant = PBVariant.find(context: activity.managedObjectContext!, name: variant)
        let path = RootPath.addEntry(activity, initialVariant)
        coordinator.present(path, style: .sheet)
    }
    
}

// MARK: - Inner types

extension ActivityDetailsViewModel {
    
    enum DisplayType {
        case list
        case chart
    }
    
}
