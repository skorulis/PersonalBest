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
    case settings
    case categories
    case categoryActivities(_ category: String)
    
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
        case .settings:
            SettingsView(viewModel: coordinator.resolve())
        case .categories:
            CategoryListView(viewModel: coordinator.resolve())
        case .categoryActivities(let category):
            CategoryActivitiesView(viewModel: coordinator.resolve(CategoryActivitiesViewModel.self, argument: category))
            
        }
    }
    
    var id: String {
        switch self {
        case .activityDetails(let activity): return "activity-details-\(activity.id)"
        case .addEntry(let activity): return "addEntry-\(activity.id)"
        case .categoryActivities(let category): return "category-\(category)"
        default: return String(describing: self)
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
