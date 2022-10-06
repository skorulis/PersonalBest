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
        var didCreate: Bool = false
        SystemActivity.allCases.forEach { act in
            if actMap[act.name] == nil {
                _ = create(act: act, catMap: catMap)
                didCreate = true
            }
        }
        if didCreate {
            try! coreData.mainContext.save()
        }
    }
    
    private func create(act: SystemActivity, catMap: [String: PBCategory]) -> PBActivity {
        let newAct = PBActivity(context: coreData.mainContext)
        newAct.name = act.name
        newAct.trackingTypeString = act.tracking.rawValue
        newAct.category = catMap[act.category.rawValue]!
        for name in act.variations {
            let newVar = PBVariant(context: coreData.mainContext)
            newVar.activity = newAct
            newVar.name = name
        }
        
        return newAct
    }
    
}
