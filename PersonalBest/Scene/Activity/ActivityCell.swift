//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivityCell {
    let activity: PBActivity
    var onInfoPressed: (() -> Void)? = nil
}

// MARK: - Rendering

extension ActivityCell: View {
    
    var body: some View {
        HStack {
            Text(activity.name)
                .typography(.body)
                .multilineTextAlignment(.leading)
            Spacer()
            maybeInfo
        }
        .font(.title)
        .foregroundColor(.black)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.5))
        )
    }
    
    @ViewBuilder
    private var maybeInfo: some View {
        if let onInfoPressed {
            Button(action: onInfoPressed ) {
                Image(systemName: "info.circle")
                    .frame(width: 40, height: 40)
            }
        }
    }
}

// MARK: - Previews

struct ActivityCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = IOC().resolve(CoreDataStore.self).mainContext
        let example = PBActivity.new(context: context, name: "Pullup", tracking: .reps)
        example.name = "Pullup"
        return VStack {
            ActivityCell(activity: example)
            
            ActivityCell(activity: example, onInfoPressed: { })
        }
        .padding(8)
    }
}

