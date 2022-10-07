//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import ASKCore
import Foundation
import SwiftUI

enum RootPath: CoordinatorPath, Hashable, Identifiable {
    
    case activityDetails(_ activity: PBActivity)
    case addEntry(_ activity: PBActivity, _ initialVariant: PBVariant?)
    case recent
    case settings
    case categories
    case categoryActivities(_ category: PBCategory)
    case workoutList
    case workout(_ workout: PBWorkout)
    case selectWorkoutActivity(_ onSelect: (PBActivity) -> Void)
    case selectVariant(_ activity: PBActivity, onSelect: (PBVariant?) -> Void)
    
    @ViewBuilder
    func render(coordinator: MainCoordinator) -> some View {
        switch self {
        case .activityDetails(let activity):
            ActivityDetailsView(viewModel: coordinator.resolve(ActivityDetailsViewModel.self, argument: activity))
        case .addEntry(let activity, let initialVariant):
            let argument = AddEntryViewModel.Argument(activity: activity, initialVariant: initialVariant)
            AddEntryView(viewModel: coordinator.resolve(AddEntryViewModel.self, argument: argument))
        case .recent:
            RecentHistoryView(viewModel: coordinator.resolve())
        case .settings:
            SettingsView(viewModel: coordinator.resolve())
        case .categories:
            CategoryListView(viewModel: coordinator.resolve())
        case .categoryActivities(let category):
            CategoryActivitiesView(viewModel: coordinator.resolve(CategoryActivitiesViewModel.self, argument: category))
        case .workoutList:
            WorkoutListView(viewModel: coordinator.resolve())
        case .workout(let workout):
            WorkoutDetailsView(viewModel: coordinator.resolve(WorkoutDetailsViewModel.self, argument: workout))
        case .selectWorkoutActivity(let onSelect):
            let arg = WorkoutActivityPickerViewModel.Argument(onSelect: onSelect)
            WorkoutActivityPickerView(viewModel: coordinator.resolve(WorkoutActivityPickerViewModel.self, argument: arg))
        case .selectVariant(let activity, onSelect: let onSelect):
            let arg = VariationListViewModel.Argument(activity: activity, onSelect: onSelect)
            VariationListView(viewModel: coordinator.resolve(VariationListViewModel.self, argument: arg))
        }
    }
    
    var id: String {
        switch self {
        case .activityDetails(let activity): return "activity-details-\(activity.id)"
        case .addEntry(let activity, _): return "addEntry-\(activity.id)"
        case .categoryActivities(let category): return "category-\(category)"
        case .workout(let workout): return "workout-\(workout)"
        case .selectWorkoutActivity(_): return "select-workout-activity"
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
