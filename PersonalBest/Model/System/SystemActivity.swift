//Created by Alexander Skorulis on 3/10/2022.

import Foundation

struct SystemActivity {
    
    let name: String
    let category: SystemCategory
    let tracking: ActivityTrackingType
    let variations: [String]
    
    init(name: String,
         category: SystemCategory,
         tracking: ActivityTrackingType,
         variations: [String] = []
    ) {
        self.name = name
        self.category = category
        self.tracking = tracking
        self.variations = variations
    }
    
}

extension SystemActivity {
    
    static var allCases: [SystemActivity] {
        return [
            // Body weight
            .init(name: "Bodyweight squat", category: .bodyWeight, tracking: .reps),
            .init(name: "Chinup", category: .bodyWeight, tracking: .reps),
            .init(name: "Dips", category: .bodyWeight, tracking: .reps),
            .init(name: "Leg raises", category: .bodyWeight, tracking: .reps, variations: ["Hanging", "Dip"]),
            .init(name: "Push ups", category: .bodyWeight, tracking: .reps, variations: ["Wide hands", "Diamond", "Fingertip", "One arm"]),
            .init(name: "Plank", category: .bodyWeight, tracking: .time, variations: ["High"]),
            .init(name: "Pull up", category: .bodyWeight, tracking: .reps, variations: ["Parallel", "Wide grip"]),
            .init(name: "Static squat", category: .bodyWeight, tracking: .time),
            .init(name: "Wall sit", category: .bodyWeight, tracking: .time),
            
            // Weightlifting
            
            .init(name: "Bench press", category: .weights, tracking: .weightlifting, variations: ["Close grip"]),
            .init(name: "Cross body hammer curl", category: .weights, tracking: .weightlifting),
            .init(name: "Deadlift", category: .weights, tracking: .weightlifting),
            .init(name: "Dumbbell row", category: .weights, tracking: .weightlifting),
            .init(name: "Dumbbell Lateral raises", category: .weights, tracking: .weightlifting, variations: ["Front", "Side"]),
            .init(name: "Hyperextensions", category: .weights, tracking: .weightlifting),
            .init(name: "Oblique cable twist", category: .weights, tracking: .weightlifting),
            .init(name: "Overhead barbell press", category: .weights, tracking: .weightlifting),
            .init(name: "Pec fly", category: .weights, tracking: .weightlifting),
            .init(name: "Shoulder press machine", category: .weights, tracking: .weightlifting),
            .init(name: "Sled push", category: .weights, tracking: .weightlifting),
            .init(name: "Tricep pushdown", category: .weights, tracking: .weightlifting),
            .init(name: "Weighted dips", category: .weights, tracking: .weightlifting),
            
            
            // Running
            .init(name: "Running", category: .running, tracking: .cardio),
            .init(name: "Rowing", category: .cardio, tracking: .cardio),
        ]
    }
    
}
