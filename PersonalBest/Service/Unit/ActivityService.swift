//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityService {
    
}

// MARK: - Computed values

extension ActivityService {
    
    var defaultActivities: [Activity] {
        return [
            .init(systemName: "Bench press", tracking: .weightlifting),
            .init(systemName: "Push ups", singleMeasure: .reps),
            .init(systemName: "Wide grip push ups", singleMeasure: .reps),
            .init(systemName: "Fingertip push ups", singleMeasure: .reps),
            .init(systemName: "Wall handstand push ups", singleMeasure: .reps),
            .init(systemName: "Dips", singleMeasure: .reps),
            .init(systemName: "Weighted dips", tracking: .weightlifting),
            .init(systemName: "Plank", singleMeasure: .time),
            .init(systemName: "High plank", singleMeasure: .time),
            .init(systemName: "Wall sit", singleMeasure: .time),
            .init(systemName: "Star plank", singleMeasure: .time),
            .init(systemName: "Static squat", singleMeasure: .time),
            .init(systemName: "Running", tracking: .cardio),
        ]
    }
    
    func activity(id: String) -> Activity? {
        return defaultActivities.first(where: {$0.id == id})
    }
    
}
