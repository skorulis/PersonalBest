//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivityCell {
    let activity: Activity
}

// MARK: - Rendering

extension ActivityCell: View {
    
    var body: some View {
        HStack {
            Text(activity.name)
            Spacer()
        }
        .font(.title)
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.5))
        )
    }
}

// MARK: - Previews

struct ActivityCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let example = Activity(systemName: "Pullup", singleMeasure: .reps)
        return VStack {
            ActivityCell(activity: example)
        }
        .padding(8)
    }
}

