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
            .init(name: "Bodyweight squat", category: .bodyWeight, tracking: .reps),
            .init(name: "Dips", category: .bodyWeight, tracking: .reps),
            .init(name: "Push ups", category: .bodyWeight, tracking: .reps),
            .init(name: "Plank", category: .bodyWeight, tracking: .time),
            .init(name: "Pull up", category: .bodyWeight, tracking: .reps),
            .init(name: "Static squat", category: .bodyWeight, tracking: .time),
            .init(name: "Wall sit", category: .bodyWeight, tracking: .time),
        ]
    }
    
}
