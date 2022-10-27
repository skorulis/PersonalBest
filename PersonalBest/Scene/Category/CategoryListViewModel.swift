//Created by Alexander Skorulis on 30/9/2022.

import ASKCore
import Foundation

// MARK: - Memory footprint

final class CategoryListViewModel: CoordinatedViewModel, ObservableObject {
    
    private let activityService: ActivityService
    
    init(activityService: ActivityService) {
        self.activityService = activityService
    }
    
}

// MARK: - Computed values

extension CategoryListViewModel {
    
}

// MARK: - Logic

extension CategoryListViewModel {

    func selected(category: PBCategory) {
        coordinator.push(RootPath.categoryActivities(category))
    }
    
}
