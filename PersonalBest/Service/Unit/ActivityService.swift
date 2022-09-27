//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityService {
    
}

// MARK: - Computed values

extension ActivityService {
    
    var defaultActivities: [Activity] {
        return [
            .init(name: "Push ups", measureTypes: [.reps]),
            .init(name: "Wide grip push ups", measureTypes: [.reps]),
            .init(name: "Fingertip push ups", measureTypes: [.reps]),
            .init(name: "Wall handstand push ups", measureTypes: [.reps]),
            .init(name: "Dips", measureTypes: [.reps]),
            .init(name: "Weighted dips", measureTypes: [.weight, .reps]),
            .init(name: "Plank", measureTypes: [.time]),
            .init(name: "High plank", measureTypes: [.time]),
            .init(name: "Wall sit", measureTypes: [.time]),
            .init(name: "Star plank", measureTypes: [.time]),
            .init(name: "Static squat", measureTypes: [.time]),
            .init(name: "Running", measureTypes: [.distance, .time]),
        ]
    }
    
}
