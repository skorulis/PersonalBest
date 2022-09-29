//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import ASKCore
import Foundation
import SwiftUI

enum RootPath: CoordinatorPath, Hashable, Identifiable {
    
    case activity
    case activityDetails(_ activity: Activity)
    case addEntry(_ activity: Activity)
    case recent
    
    @ViewBuilder
    func render(coordinator: MainCoordinator) -> some View {
        switch self {
        case .activity:
            ActivityListView(viewModel: coordinator.resolve())
        case .activityDetails(let activity):
            ActivityDetailsView(viewModel: coordinator.resolve(ActivityDetailsViewModel.self, argument: activity))
        case .addEntry(let activity):
            AddEntryView(viewModel: coordinator.resolve(AddEntryViewModel.self, argument: activity))
        case .recent:
            RecentHistoryView(viewModel: coordinator.resolve())
        }
    }
    
    var id: String {
        switch self {
        case .activity: return "activity"
        case .activityDetails(let activity): return "activity-details-\(activity.id)"
        case .addEntry(let activity): return "addEntry-\(activity.id)"
        case .recent: return "recent"
        }
    }
    
}

extension CoordinatorPath where Self: Identifiable {
 
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
