//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import CoreData

// MARK: - Memory footprint

final class RecentHistoryViewModel: CoordinatedViewModel, ObservableObject {
 
    private let recordsStore: RecordsStore
    private let activityService: ActivityService
    private let recordAccess: RecordEntryAccess
    
    @Published var records: [RecentEntry] = []
    
    init(recordsStore: RecordsStore,
         activityService: ActivityService,
         recordAccess: RecordEntryAccess
    ) {
        self.recordsStore = recordsStore
        self.activityService = activityService
        self.recordAccess = recordAccess
        super.init()
        self.records = rebuildList()
        self.recordsStore.objectWillChange
            .delayedChange()
            .sink { [unowned self] _ in
                self.records = self.rebuildList()
            }
            .store(in: &subscribers)
    }
    
}

// MARK: - Logic

extension RecentHistoryViewModel {
    
    func entry(activity: PBActivity) -> RecentEntry {
        let top = recordAccess.topValues(activity: activity)
        return RecentEntry(activity: activity, value: top.values.first!)
    }
    
    func show(activity: PBActivity) -> () -> Void {
        return { [unowned self] in
             self.coordinator.push(RootPath.activityDetails(activity))
        }
    }
    
}

// MARK: - Inner types

struct RecentEntry: Identifiable {
    
    let activity: PBActivity
    let value: TopRecord
    
    var id: NSManagedObjectID { activity.objectID }
    
}
