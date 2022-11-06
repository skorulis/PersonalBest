//Created by Alexander Skorulis on 29/9/2022.

import ASKCore
import Foundation
import CoreData
import SwiftUI

// MARK: - Memory footprint

final class RecentHistoryViewModel: CoordinatedViewModel, ObservableObject {
 
    private let recordsStore: RecordsStore
    private let activityService: ActivityService
    private let recordAccess: RecordEntryAccess
    
    @Published var toDelete: RecentEntry?
    @Published var overlayPath: RootPath?
    
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
    
    func collect(activities: [PBActivity]) -> [RecentEntry] {
        let recent = activities.flatMap { act in
            return entries(activity: act)
        }
        return recent.sorted { a, b in
            if a.value.date == b.value.date {
                return a.key > b.key
            }
            return a.value.date > b.value.date
        }
    }
    
    func entries(activity: PBActivity) -> [RecentEntry] {
        let top = recordAccess.topValues(activity: activity)
        return top.compactMap { (key, value) in
            guard key.measurement == activity.primaryMeasure else { return nil }
            return RecentEntry(activity: activity, key: key, value: value)
        }
    }
    
    func show(activity: PBActivity) {
        self.overlayPath = RootPath.activityDetails(activity) { [unowned self] in
            self.overlayPath = nil
        }
    }
    
    func deleteAction(entry: RecentEntry) -> () -> Void {
        return { [unowned self] in
            self.toDelete = entry
        }
    }
    
    func confirmDelete(entry: RecentEntry) {
        self.toDelete = nil
        let context = entry.activity.managedObjectContext!
        let mainPred = NSPredicate(format: "activity = %@", entry.activity)
        
        let fetch = PBRecordEntry.fetch()
        fetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mainPred,
                                                                              autoPredicate(entry: entry),
                                                                              varientPredicate(entry: entry)
                                                                             ])
        
        let matches = try! context.fetch(fetch)
        matches.forEach { context.delete($0) }
        
        try! context.save()
    }
    
    private func autoPredicate(entry: RecentEntry) -> NSPredicate {
        if let autoType = entry.key.autoType {
            return NSPredicate(format: "autoTypeString = %@", autoType.rawValue)
        } else {
            return NSPredicate(format: "autoTypeString == NULL")
        }
    }
    
    private func varientPredicate(entry: RecentEntry) -> NSPredicate {
        if let variantString = entry.key.variant,
           let variant = PBVariant.find(activity: entry.activity, name: variantString) {
            return NSPredicate(format: "variant = %@", variant)
        } else {
            return NSPredicate(format: "variant == NULL")
        }
    }
    
    func addRecord() {
        let path = RootPath.selectWorkoutActivity { [unowned self] activity in
            print("Finish")
            let addPath = RootPath.addEntry(activity, nil)
            self.coordinator.push(addPath)
        }
        coordinator.push(path)
    }
    
}

// MARK: - Inner types

struct RecentEntry: Identifiable {
    
    let activity: PBActivity
    let key: TopValueKey
    let value: TopRecord
    
    var id: String {
        return "\(activity.objectID)-\(key.id)"
    }
    
    var name: String {
        if let suffix = key.suffix {
            return "\(activity.name) \(suffix)"
        } else {
            return activity.name
        }
    }
    
}
