//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityListViewModel: CoordinatedViewModel, ObservableObject {
    
    private let service: ActivityService
    
    @Published var searchText: String = ""
    
    init(service: ActivityService) {
        self.service = service
        super.init()
    }
    
}

// MARK: - Computed values

extension ActivityListViewModel {
    
    var activities: [Activity] {
        return service.defaultActivities
    }
}

// MARK: - Logic

extension ActivityListViewModel {
    
    func add() {
        
    }
    
}
