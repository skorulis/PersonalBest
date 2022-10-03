//Created by Alexander Skorulis on 3/10/2022.

import Foundation

struct SystemActivity {
    
    let name: String
    let category: SystemCategory
    let tracking: ActivityTrackingType
    
}

extension SystemActivity {
    
    static var allCases: [SystemActivity] {
        return [
            // Body weight
            .init(name: "Bodyweight squat", category: .bodyWeight, tracking: .reps),
            .init(name: "Dips", category: .bodyWeight, tracking: .reps),
            .init(name: "Push ups", category: .bodyWeight, tracking: .reps),
            .init(name: "Plank", category: .bodyWeight, tracking: .time),
            .init(name: "Pull up", category: .bodyWeight, tracking: .reps),
            .init(name: "Static squat", category: .bodyWeight, tracking: .time),
            .init(name: "Wall sit", category: .bodyWeight, tracking: .time),
            
            // Weightlifting
            
            .init(name: "Bench press", category: .weights, tracking: .weightlifting),
            .init(name: "Weighted dips", category: .weights, tracking: .weightlifting),
            .init(name: "Shoulder press machine", category: .weights, tracking: .weightlifting),
            .init(name: "Oblique cable twist", category: .weights, tracking: .weightlifting),
            .init(name: "Tricep pushdown", category: .weights, tracking: .weightlifting),
            
            // Running
            .init(name: "Running", category: .running, tracking: .cardio)
        ]
    }
    
}
