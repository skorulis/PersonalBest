//Created by Alexander Skorulis on 3/10/2022.

import Foundation

struct SystemActivity {
    
    let name: String
    let category: SystemCategory
    let tracking: ActivityTrackingType
    let pushPull: PushPullCategory
    let variations: [String]
    
    init(name: String,
         category: SystemCategory,
         tracking: ActivityTrackingType,
         pushPull: PushPullCategory,
         variations: [String] = []
    ) {
        self.name = name
        self.category = category
        self.tracking = tracking
        self.pushPull = pushPull
        self.variations = variations
    }
    
}

extension SystemActivity {
    
    static var allCases: [SystemActivity] {
        return [
            // Body weight
            .init(
                name: "Bodyweight squat",
                category: .bodyWeight,
                tracking: .reps,
                pushPull: .legs
            ),
            .init(
                name: "Chinup",
                category: .bodyWeight,
                tracking: .reps,
                pushPull: .pull
            ),
            .init(
                name: "Dips",
                category: .bodyWeight,
                tracking: .reps,
                pushPull: .push
            ),
            .init(
                name: "Leg raises",
                category: .bodyWeight,
                tracking: .reps,
                pushPull: .legs,
                variations: ["Hanging", "Dip"]
            ),
            .init(
                name: "Push ups",
                category: .bodyWeight,
                tracking: .reps,
                pushPull: .push,
                variations: ["Wide hands", "Diamond", "Fingertip", "One arm"]
            ),
            .init(
                name: "Plank",
                category: .bodyWeight,
                tracking: .time,
                pushPull: .legs,
                variations: ["High"]
            ),
            .init(
                name: "Pull up",
                category: .bodyWeight,
                tracking: .reps,
                pushPull: .pull,
                variations: ["Parallel", "Wide grip"]
            ),
            .init(
                name: "Static squat",
                category: .bodyWeight,
                tracking: .time,
                pushPull: .legs
            ),
            .init(
                name: "Toes to bar",
                category: .bodyWeight,
                tracking: .time,
                pushPull: .legs
            ),
            .init(
                name: "Wall sit",
                category: .bodyWeight,
                tracking: .time,
                pushPull: .legs
            ),
            
            // Weight machines
            
            .init(
                name: "Cable crossover",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            .init(
                name: "Chest press machine",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            .init(
                name: "Face pull",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull
            ),
            .init(
                name: "Lat pulldown",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull
            ),
            .init(
                name: "Oblique cable twist",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .legs
            ),
            .init(
                name: "Pec fly",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            .init(
                name: "Shoulder press machine",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            .init(
                name: "Seated cable row",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull
            ),
            .init(
                name: "Tricep pushdown",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            
            // Free weights
            
            .init(
                name: "Barbell row",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull,
                variations: ["Pendlay", "Yates"]
            ),
            .init(
                name: "Barbell squat",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .legs
            ),
            .init(
                name: "Bench press",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push,
                variations: ["Close grip"]
            ),
            .init(
                name: "Cross body hammer curl",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull
            ),
            .init(
                name: "Deadlift",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull
            ),
            .init(
                name: "Dumbbell curl",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull
            ),
            .init(
                name: "Dumbbell row",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .pull
            ),
            .init(
                name: "Dumbbell Lateral raises",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push,
                variations: ["Front", "Side"]
            ),
            .init(
                name: "Hyperextensions",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .legs
            ),
            .init(
                name: "Overhead barbell press",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            .init(
                name: "Sled push",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            .init(
                name: "Weighted dips",
                category: .weights,
                tracking: .weightlifting,
                pushPull: .push
            ),
            
            
            // Running
            .init(
                name: "Running",
                category: .cardio,
                tracking: .cardio,
                pushPull: .legs
            ),
            .init(
                name: "Rowing",
                category: .cardio,
                tracking: .cardio,
                pushPull: .pull
            ),
        ]
    }
    
}
