//Created by Alexander Skorulis on 29/9/2022.

import ASKCore
import Foundation
import CoreData
import SwiftUI

// MARK: - Memory footprint

final class RecentHistoryViewModel: CoordinatedViewModel, ObservableObject {
 
    private let activityService: ActivityService
    private let recordAccess: RecordEntryAccess
    
    @Published var toDelete: PBRecordEntry?
    @Published var overlayPath: RootPath?
    
    @Published var expandedStatus: [ObjectIdentifier: Bool] = [:]
    
    init(activityService: ActivityService,
         recordAccess: RecordEntryAccess
    ) {
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
    
    func grouped(activities: [PBActivity]) -> [GroupedRecords] {
        let groups = activities.map { activity in
            let items = entries(activity: activity)
            return GroupedRecords(activity: activity, entries: items)
        }
        
        return groups.sorted { e1, e2 in
            return e1.latestDate > e2.latestDate
        }
    }
    
    func entries(activity: PBActivity) -> [PBRecordEntry] {
        let top = recordAccess.topRecords(activity: activity)
        let items = top.map { (_, value) in
            return value
        }
        return items.sorted()
        
    }
    
    func show(activity: PBActivity) {
        self.overlayPath = RootPath.activityDetails(activity) { [unowned self] in
            self.overlayPath = nil
        }
    }
    
    func show(entry: PBRecordEntry) {
        self.overlayPath = RootPath.activityDetails(entry.activity) { [unowned self] in
            self.overlayPath = nil
        }
    }
    
    func deleteAction(entry: PBRecordEntry) {
        self.toDelete = entry
    }
    
    func confirmDelete(entry: PBRecordEntry) {
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
    
    private func autoPredicate(entry: PBRecordEntry) -> NSPredicate {
        if let autoType = entry.key.autoType {
            return NSPredicate(format: "autoTypeString = %@", autoType.rawValue)
        } else {
            return NSPredicate(format: "autoTypeString == NULL")
        }
    }
    
    private func varientPredicate(entry: PBRecordEntry) -> NSPredicate {
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
    
    func expandedBinding(_ activity: PBActivity) -> Binding<Bool> {
        return Binding<Bool> { [unowned self] in
            return self.expandedStatus[activity.id] ?? false
        } set: { [unowned self] newValue in
            self.expandedStatus[activity.id] = newValue
        }
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
