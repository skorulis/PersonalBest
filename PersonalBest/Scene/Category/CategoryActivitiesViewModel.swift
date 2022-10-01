//Created by Alexander Skorulis on 30/9/2022.

import Foundation

// MARK: - Memory footprint

final class CategoryActivitiesViewModel: CoordinatedViewModel, ObservableObject {

    let category: String
    private let activityService: ActivityService
    
    init(category: String,
         activityService: ActivityService
    ) {
        self.category = category
        self.activityService = activityService
    }
    
    
}

// MARK: - Computed values

extension CategoryActivitiesViewModel {
    
    var activities: [Activity] {
        return activityService.defaultActivities.filter { $0.category == category }
    }
    
}

extension CategoryActivitiesViewModel {
    
    func addActivity() {
        
    }
    
    func show(activity: Activity) -> () -> Void {
        return { [unowned self] in
            coordinator.push(.activityDetails(activity))
        }
    }
    
}
