//Created by Alexander Skorulis on 18/12/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct GroupedActivityCell {
    let entries: [RecentEntry]
    @Binding var expanded: Bool
}

// MARK: - Rendering

extension GroupedActivityCell: View {
    
    var body: some View {
        VStack {
            topSection
                .zIndex(1)
            middleSection
            bottomSection
        }
    }
    
    private var bottomSection: some View {
        HStack {
            Spacer()
            Text(DateFormatter.mediumDate.string(from: latestDate))
                .typography(.body)
                .opacity(expanded ? 0 : 1)
        }
        
    }
    
    @ViewBuilder
    private var middleSection: some View {
        if expanded {
            ForEach(entries) { entry in
                entryRow(entry)
            }
        }
    }
    
    private func entryRow(_ entry: RecentEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                RecordValueDisplay(value: entry.value.value, unit: entry.value.unit)
                RecordEntryTags(key: entry.key.recordKey)
            }
            Spacer()
            Text(DateFormatter.mediumDate.string(from: entry.value.date))
                .typography(.body)
        }
        
    }
    
    private var topSection: some View {
        HStack {
            Text(activity.name)
                .typography(.title)
            Spacer()
            Button(action: {expanded.toggle()}) {
                ASKIcon.chevronLeft.small
                    .rotationEffect(iconRotation)
            }
            .foregroundColor(.primary)
        }
    }
    
    private var iconRotation: Angle {
        expanded ? .degrees(90) : .degrees(-90)
    }
}

// MARK: - Computed values

private extension GroupedActivityCell {
    
    var activity: PBActivity {
        return entries[0].activity
    }
    
    var latestDate: Date {
        return entries.map { $0.value.date }.max()!
    }
}

// MARK: - Previews

struct GroupedActivityCell_Previews: PreviewProvider {
    
    static let ioc = IOC()
    
    static var previews: some View {
        let recordAccess = ioc.resolve(RecordEntryAccess.self)
        let context = ioc.resolve(CoreDataStore.self).mainContext
        
        let activity = PreviewData.weightActivity(context)
        
        let entry = PBRecordEntry.new(activity: activity, values: [.reps: 10, .weight: 2000])
        
        let recent = PreviewData.toRecent(entry: entry, access: recordAccess)
        
        return VStack {
            StatefulPreviewWrapper(false) { expanded in
                GroupedActivityCell(entries: [recent], expanded: expanded)
            }
        }
        .padding(16)
    }
}
