//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import ASKCore
import Foundation
import SwiftUI

enum RootPath: BoundCoordinatorPath, AnalyticsCoordinatorPath, Hashable, Identifiable {
    
    case activityDetails(_ activity: PBActivity, _ customDismiss: (() -> Void)?)
    case addEntry(_ activity: PBActivity, _ initialVariant: PBVariant?)
    case recent
    case settings
    case categories
    case categoryActivities(_ category: PBCategory)
    case workoutList
    case workout(_ workout: PBWorkout)
    case selectWorkoutActivity(_ onSelect: (PBActivity) -> Void)
    case selectVariant(_ activity: PBActivity, onSelect: (PBVariant?) -> Void)
    case newVariant(_ activity: PBActivity)
    case editActivity(_ onSave: (PBActivity) -> Void)
    
    @ViewBuilder
    func render(coordinator: StandardCoordinator) -> some View {
        switch self {
        case .activityDetails(let activity, let customDismiss):
            let argument = ActivityDetailsViewModel.Argument(activity: activity, customDismiss: customDismiss)
            ActivityDetailsView(viewModel: coordinator.resolve(ActivityDetailsViewModel.self, argument: argument))
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
        case .newVariant(let activity):
            NewVariationView(viewModel: coordinator.resolve(NewVariationViewModel.self, argument: activity))
        case .editActivity(let onSave):
            let arg = ActivityEditViewModel.Argument(onSave: onSave)
            ActivityEditView(viewModel: coordinator.resolve(ActivityEditViewModel.self, argument: arg))
        }
    }
    
    var id: String {
        switch self {
        case .activityDetails(let activity, _): return "activity-details-\(activity.id)"
        case .addEntry(let activity, _): return "addEntry-\(activity.id)"
        case .categoryActivities(let category): return "category-\(category)"
        case .workout(let workout): return "workout-\(workout)"
        case .selectWorkoutActivity(_): return "select-workout-activity"
        default: return String(describing: self)
        }
    }
    
    public var pathName: String {
        switch self {
        case .activityDetails: return "activity-details"
        case .addEntry: return "addEntry"
        case .categoryActivities: return "category"
        case .workout: return "workout"
        case .selectWorkoutActivity: return "select-workout-activity"
        default: return id
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
