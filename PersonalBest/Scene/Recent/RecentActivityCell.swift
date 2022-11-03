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
    
    private var tags: some View {
        HStack {
            if let variant = recent.key.variant {
                TextBadge(text: variant, color: .blue.opacity(0.3))
            }
            if let autoType = recent.key.autoType {
                TextBadge(text: autoType.displayText, color: .orange.opacity(0.3))
            }
        }
    }
    
    private var content: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recent.activity.name)
                    .typography(.title)
                    .multilineTextAlignment(.leading)
                tags
                
            }
            Spacer()
            VStack(alignment: .leading) {
                RecordValueDisplay(value: recent.value.value, unit: recent.value.unit)
                Text(DateFormatter.mediumDate.string(from: recent.value.date))
                    .typography(.body)
            }
        }
        .foregroundColor(.primary)
        .padding(2)
    }
    
}

// MARK: - Previews

struct RecentActivityCell_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        let ioc = IOC()
        let recordAccess = ioc.resolve(RecordEntryAccess.self)
        let context = ioc.resolve(CoreDataStore.self).mainContext
        
        let activity = PreviewData.weightActivity(context)
        
        let entry = PBRecordEntry.new(activity: activity, values: [.reps: 10, .weight: 20])
        
        let recent = toRecent(entry: entry, access: recordAccess)
        
        return VStack {
            RecentActivityCell(recent: recent,
                               onPress: {_ in })
        }
        .padding(16)
    }
    
    private static func toRecent(entry: PBRecordEntry,
                                 access: RecordEntryAccess) -> RecentEntry {
        let top = access.topValues(activity: entry.activity)
        let key = entry.topValueKey(type: .weight)
        return RecentEntry(activity: entry.activity, key: key, value: top.values.first!)
    }
}

