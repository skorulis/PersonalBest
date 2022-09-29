//Created by Alexander Skorulis on 29/9/2022.

import Foundation

// MARK: - Memory footprint

final class RecentHistoryViewModel: CoordinatedViewModel, ObservableObject {
 
    private let recordsStore: RecordsStore
    private let activityService: ActivityService
    
    @Published var records: [RecentEntry] = []
    
    init(recordsStore: RecordsStore,
         activityService: ActivityService
    ) {
        self.recordsStore = recordsStore
        self.activityService = activityService
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
    
    func rebuildList() -> [RecentEntry] {
        let activityIds = Array(recordsStore.records.keys)
        return activityIds.compactMap { id -> RecentEntry? in
            guard let activity = self.activityService.activity(id: id) else {
                return nil
            }
            guard let top = self.recordsStore.topValue(activity: activity, type: activity.primaryMeasure) else {
                return nil
            }
            return RecentEntry(activity: activity, value: top)
        }
    }
    
    func show(activity: Activity) -> () -> Void {
        return { [unowned self] in
            self.coordinator.push(RootPath.activityDetails(activity))
        }
    }
    
}

// MARK: - Inner types

struct RecentEntry: Identifiable {
    
    let activity: Activity
    let value: TopRecord
    
    var id: String { activity.id }
    
}
