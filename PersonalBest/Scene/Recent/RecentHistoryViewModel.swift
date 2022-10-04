//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import CoreData
import SwiftUI

// MARK: - Memory footprint

final class RecentHistoryViewModel: CoordinatedViewModel, ObservableObject {
 
    private let recordsStore: RecordsStore
    private let activityService: ActivityService
    private let recordAccess: RecordEntryAccess
    
    @Published var toDelete: PBActivity?
    
    init(recordsStore: RecordsStore,
         activityService: ActivityService,
         recordAccess: RecordEntryAccess
    ) {
        self.recordsStore = recordsStore
        self.activityService = activityService
        self.recordAccess = recordAccess
        super.init()
    }
    
}

// MARK: - Computed values

extension RecentHistoryViewModel {
    
    var alertShowingBinding: Binding<Bool> {
        return Binding<Bool> { [unowned self] in
            return self.toDelete != nil
        } set: { [unowned self] newValue in
            if !newValue && self.toDelete != nil {
                self.toDelete = nil
            }
        }
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
    
    func deleteAction(activity: PBActivity) -> () -> Void {
        return { [unowned self] in
            self.toDelete = activity
        }
    }
    
    func confirmDelete(activity: PBActivity) {
        self.toDelete = nil
        let context = activity.managedObjectContext!
        activity.records.forEach { context.delete($0) }
        try! context.save()
    }
    
}

// MARK: - Inner types

struct RecentEntry: Identifiable {
    
    let activity: PBActivity
    let value: TopRecord
    
    var id: NSManagedObjectID { activity.objectID }
    
}
