//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityService {
    
}

// MARK: - Computed values

extension ActivityService {
    
    var defaultActivities: [Activity] {
        return [bodyweightActivities, weightliftingActivities, runningActivities].flatMap { $0 }
    }
    
    var bodyweightActivities: [Activity] {
        return [
            .init(systemName: "Bodyweight squat", category: .bodyWeight, singleMeasure: .reps),
            .init(systemName: "Bosu ball squat", category: .bodyWeight, singleMeasure: .reps),
            .init(systemName: "Dips", category: .bodyWeight, singleMeasure: .reps),
            .init(systemName: "Fingertip push ups", category: .bodyWeight, singleMeasure: .reps),
            .init(systemName: "High plank", category: .bodyWeight, singleMeasure: .time),
            .init(systemName: "Plank", category: .bodyWeight, singleMeasure: .time),
            .init(systemName: "Pull up", category: .bodyWeight, singleMeasure: .time),
            .init(systemName: "Push ups", category: .bodyWeight, singleMeasure: .reps),
            .init(systemName: "Star plank", category: .bodyWeight, singleMeasure: .time),
            .init(systemName: "Static squat", category: .bodyWeight, singleMeasure: .time),
            .init(systemName: "Wide grip push ups", category: .bodyWeight, singleMeasure: .reps),
            .init(systemName: "Wall handstand push ups", category: .bodyWeight, singleMeasure: .reps),
            .init(systemName: "Wall sit", category: .bodyWeight, singleMeasure: .time),
        ]
    }
    
    var weightliftingActivities: [Activity] {
        return [
            .init(systemName: "Bench press", category: .weights, tracking: .weightlifting),
            .init(systemName: "Weighted dips", category: .weights, tracking: .weightlifting),
            .init(systemName: "Shoulder press machine", category: .weights, tracking: .weightlifting),
            .init(systemName: "Oblique cable twist", category: .weights, tracking: .weightlifting),
            .init(systemName: "Tricep pushdown", category: .weights, tracking: .weightlifting)
            ]
    }
    
    var runningActivities: [Activity] {
        return [
            .init(systemName: "Running", category: .running, tracking: .cardio)
            ]
    }
    
    func activity(id: String) -> Activity? {
        return defaultActivities.first(where: {$0.id == id})
    }
    
    var categories: [String] {
        return SystemCategory.allCases.map { $0.rawValue }
    }
    
}
