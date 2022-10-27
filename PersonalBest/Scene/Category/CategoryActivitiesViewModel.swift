//Created by Alexander Skorulis on 30/9/2022.

import ASKCore
import Foundation

// MARK: - Memory footprint

final class CategoryActivitiesViewModel: CoordinatedViewModel, ObservableObject {

    let category: PBCategory
    private let activityService: ActivityService
    
    init(category: PBCategory,
         activityService: ActivityService
    ) {
        self.category = category
        self.activityService = activityService
    }
}

extension CategoryActivitiesViewModel {
    
    func addActivity() {
        
    }
    
    func show(activity: PBActivity) -> () -> Void {
        return { [unowned self] in
            coordinator.push(RootPath.activityDetails(activity, nil))
        }
    }
    
}
