//Created by Alexander Skorulis on 18/12/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct GroupedActivityCell {
    let entries: [RecentEntry]
    @Binding var expanded: Bool
    let onDelete: (RecentEntry) -> Void
    let onSelect: (RecentEntry) -> Void
    let onPress: (PBActivity) -> Void
    
}

// MARK: - Rendering

extension GroupedActivityCell: View {
    
    var body: some View {
        topSection
        bottomSection
        entryList
    }
    
    private var bottomSection: some View {
        HStack {
            Text("\(entries.count) records")
            Spacer()
            Text(DateFormatter.mediumDate.string(from: latestDate))
                .typography(.body)
            toggleButton
        }
        
    }
    
    @ViewBuilder
    private var entryList: some View {
        if expanded {
            ForEach(entries) { entry in
                Button(action: {onSelect(entry) }) {
                    entryRow(entry)
                }
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
        .swipeActions(allowsFullSwipe: false) {
            Button(action: {onDelete(entry)}) {
                Text("Delete")
            }
            .tint(.red)
        }
    }
    
    private var topSection: some View {
        Button(action: { onPress(activity) }) {
            HStack {
                Text(activity.name)
                    .typography(.title)
                Spacer()
            }
        }
        .foregroundColor(.primary)
    }
    
    private var toggleButton: some View {
        Button(action: { withAnimation {
            expanded.toggle() } }) {
            ASKIcon.chevronLeft.small
                .rotationEffect(iconRotation)
        }
        .foregroundColor(.primary)
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
        
        let activity = PreviewData.longActivity(context)
        
        let entry = PBRecordEntry.new(activity: activity, values: [.reps: 10, .weight: 2000])
        
        let recent = PreviewData.toRecent(entry: entry, access: recordAccess)
        
        return StatefulPreviewWrapper(false) { expanded in
            List {
                Section {
                    GroupedActivityCell(
                        entries: [recent],
                        expanded: expanded,
                        onDelete: { _ in },
                        onSelect: { _ in },
                        onPress: { _ in }
                    )
                }
                
                Section {
                    GroupedActivityCell(
                        entries: [recent],
                        expanded: expanded,
                        onDelete: { _ in },
                        onSelect: { _ in },
                        onPress: { _ in }
                    )
                }
            }
            .listStyle(.plain)
        }
    }
}

