//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityService {
    
}

// MARK: - Computed values

extension ActivityService {
    
    var defaultActivities: [Activity] {
        return [
            .init(systemName: "Bench press", measureTypes: [.weight, .reps]),
            .init(systemName: "Push ups", measureTypes: [.reps]),
            .init(systemName: "Wide grip push ups", measureTypes: [.reps]),
            .init(systemName: "Fingertip push ups", measureTypes: [.reps]),
            .init(systemName: "Wall handstand push ups", measureTypes: [.reps]),
            .init(systemName: "Dips", measureTypes: [.reps]),
            .init(systemName: "Weighted dips", measureTypes: [.weight, .reps]),
            .init(systemName: "Plank", measureTypes: [.time]),
            .init(systemName: "High plank", measureTypes: [.time]),
            .init(systemName: "Wall sit", measureTypes: [.time]),
            .init(systemName: "Star plank", measureTypes: [.time]),
            .init(systemName: "Static squat", measureTypes: [.time]),
            .init(systemName: "Running", measureTypes: [.distance, .time]),
        ]
    }
    
    func activity(id: String) -> Activity? {
        return defaultActivities.first(where: {$0.id == id})
    }
    
}
