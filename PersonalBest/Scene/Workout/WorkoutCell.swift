//Created by Alexander Skorulis on 1/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutCell {
    
    let workout: Workout
    
}

// MARK: - Rendering

extension WorkoutCell: View {
    
    var body: some View {
        VStack {
            Text(DateFormatter.mediumDate.string(from: workout.startDate))
        }
    }
}

// MARK: - Previews

struct WorkoutCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let workout = Workout.new()
        return WorkoutCell(workout: workout)
    }
}

