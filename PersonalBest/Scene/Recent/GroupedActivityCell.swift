//Created by Alexander Skorulis on 18/12/2022.

import ASSwiftUI
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
            HStack {
                Text(activity.name)
                Spacer()
                Button(action: {expanded.toggle()}) {
                    Text("Toggle")
                }
            }
            
            if expanded {
                ForEach(entries) { entry in
                    RecentActivityCell(recent: entry, onPress: { _ in })
                }
            }
        }
    }
}

// MARK: - Computed values

private extension GroupedActivityCell {
    
    var activity: PBActivity {
        return entries[0].activity
    }
}

// MARK: - Previews

struct GroupedActivityCell_Previews: PreviewProvider {
    
    static let ioc = IOC()
    
    static var previews: some View {
        let recordAccess = ioc.resolve(RecordEntryAccess.self)
        let context = ioc.resolve(CoreDataStore.self).mainContext
        
        let activity = PreviewData.weightActivity(context)
        
        let entry = PBRecordEntry.new(activity: activity, values: [.reps: 10, .weight: 20])
        
        let recent = PreviewData.toRecent(entry: entry, access: recordAccess)
        
        return VStack {
            StatefulPreviewWrapper(false) { expanded in
                GroupedActivityCell(entries: [recent], expanded: expanded)
            }
        }
        .padding(16)
    }
}
