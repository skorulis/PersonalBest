//Created by Alexander Skorulis on 6/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RecentActivityCell {
    let recent: RecentEntry
    let onPress: (PBActivity) -> Void
}

// MARK: - Rendering

extension RecentActivityCell: View {
    
    var body: some View {
        Button(action: { onPress(recent.activity) }) {
            content
        }
        .buttonStyle(ShadowButtonStyle())
    }
    
    private var content: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recent.activity.name)
                    .typography(.title)
                    .multilineTextAlignment(.leading)
                Text(DateFormatter.mediumDate.string(from: recent.value.date))
                    .typography(.body)
            }
            Spacer()
            VStack(alignment: .leading) {
                RecordValueDisplay(value: recent.value.value, unit: recent.value.unit)
            }
        }
        .foregroundColor(.primary)
        .padding(12)
    }
}

// MARK: - Previews

struct RecentActivityCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let recordAccess = ioc.resolve(RecordEntryAccess.self)
        let context = ioc.resolve(CoreDataStore.self).mainContext
        
        let activity = PBActivity(context: context)
        activity.name = "Bench press"
        activity.trackingType = .weightlifting
        
        let entry = PBRecordEntry.new(activity: activity, values: [.reps: 10, .weight: 20])
        activity.records.insert(entry)
        
        let top = recordAccess.topValues(activity: activity)
        let recent = RecentEntry(activity: activity, value: top.values.first!)
        
        return VStack {
            RecentActivityCell(recent: recent, onPress: {_ in })
        }
        .padding(16)
    }
}

