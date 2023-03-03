//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityService {
    
    private let coreData: CoreDataStore
    
    init(coreData: CoreDataStore) {
        self.coreData = coreData
    }
    
}

// MARK: - Computed values

extension ActivityService {
    
    var categoryMap: [String: PBCategory] {
        let query = PBCategory.fetch()
        let cats = (try? coreData.mainContext.fetch(query)) ?? []
        
        return Dictionary.init(grouping: cats) { $0.name }.mapValues { $0[0] }
    }
    
    func setupSystemData() {
        let cats = createMissingCategories()
        createMissingActivities(catMap: cats)
    }
    
    func createMissingCategories() -> [String: PBCategory] {
        var map = categoryMap
        var didCreate: Bool = false
        SystemCategory.allCases.forEach { cat in
            if map[cat.rawValue] == nil {
                let newCat = PBCategory(context: coreData.mainContext)
                newCat.name = cat.rawValue
                didCreate = true
                map[cat.rawValue] = newCat
            }
        }
        if didCreate {
            try! coreData.mainContext.save()
        }
        return map
    }
    
    func createMissingActivities(catMap: [String: PBCategory]) {
        let query = PBActivity.fetch()
        let activities = (try? coreData.mainContext.fetch(query)) ?? []
        let actMap = Dictionary.init(grouping: activities) { $0.name }.mapValues { $0[0] }
        SystemActivity.allCases.forEach { act in
            if let pbActivity = actMap[act.name] {
                update(sys: act, activity: pbActivity, catMap: catMap)
            } else {
                _ = create(act: act, catMap: catMap)
            }
        }
        try! coreData.mainContext.save()
    }
    
    private func create(act: SystemActivity, catMap: [String: PBCategory]) -> PBActivity {
        let newAct = PBActivity(context: coreData.mainContext)
        newAct.name = act.name
        update(sys: act, activity: newAct, catMap: catMap)
        for name in act.variations {
            let newVar = PBVariant(context: coreData.mainContext)
            newVar.activity = newAct
            newVar.name = name
        }
        
        return newAct
    }
    
    private func update(sys: SystemActivity, activity: PBActivity, catMap: [String: PBCategory]) {
        activity.trackingTypeString = sys.tracking.rawValue
        activity.category = catMap[sys.category.rawValue]!
        activity.pushPull = sys.pushPull
    }
    
}
