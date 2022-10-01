//Created by Alexander Skorulis on 30/9/2022.

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
    
    var categories: [String] {
        return activityService.categories
    }
    
    var categoryRows: [(String, String)] {
        let cats = categories
        var result = [(String, String)]()
        for i in stride(from: 0, to: cats.count - 1, by: 2) {
            let row = (cats[i], cats[i + 1])
            result.append(row)
        }
        
        return result
    }
    
}

// MARK: - Logic

extension CategoryListViewModel {

    func selected(category: String) {
        coordinator.push(RootPath.categoryActivities(category))
    }
    
}
