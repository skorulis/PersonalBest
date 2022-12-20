//Created by Alexander Skorulis on 20/12/2022.

import Foundation

struct GroupedRecords: Identifiable {
    let activity: PBActivity
    let entries: [PBRecordEntry]
    
    var id: ObjectIdentifier {
        return activity.id
    }
    
    var latestDate: Date {
        return entries.map { $0.date }.max()!
    }
}
