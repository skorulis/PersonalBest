//Created by Alexander Skorulis on 27/9/2022.

import ASKCore
import Foundation
import SwiftUI

// MARK: - Memory footprint

final class ActivityDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    let activity: PBActivity
    let customDismiss: (() -> Void)?
    private let graphGenerator: GraphDataGenerator
    private let coreDataStore: CoreDataStore
    
    @Published var recordBreakdown: ActivityBreakdown
    @Published var displayType: DisplayType = .chart
    @Published var variant: String = PBVariant.none
    @Published var showingSettings: Bool = false
    
    init(argument: Argument,
         graphGenerator: GraphDataGenerator,
         coreDataStore: CoreDataStore
    ) {
        self.activity = argument.activity
        self.customDismiss = argument.customDismiss
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

// MARK: - Inner types

extension ActivityDetailsViewModel {
    
    struct Argument {
        let activity: PBActivity
        let customDismiss: (() -> Void)?
    }
    
}

// MARK: - Computed values

extension ActivityDetailsViewModel {
 
    var lines: [GraphLine]? {
        let key = RecordKey(autoType: nil, variant: variant)
        return recordBreakdown.lineVariants[key]
    }
    
    var topValueKey: TopValueKey {
        return TopValueKey(measurement: activity.primaryMeasure,
                           autoType: nil,
                           variant: variant
        )
    }
    
    var highlightID: String {
        return "\(activity.objectID)-\(topValueKey.id)"
    }
    
}

// MARK: - Logic

extension ActivityDetailsViewModel {
    
    func addEntry() {
        let initialVariant = PBVariant.find(activity: activity, name: variant)
        let path = RootPath.addEntry(activity, initialVariant)
        coordinator.present(path, style: .sheet)
    }
    
    func close() {
        if let custom = customDismiss {
            custom()
        } else {
            self.back()
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
