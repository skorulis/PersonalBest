//Created by Alexander Skorulis on 2/10/2022.

import Foundation

final class WorkoutActivityPickerViewModel: CoordinatedViewModel, ObservableObject {
    
    private let onSelect: (Activity) -> Void
    private let activityService: ActivityService
    
    init(argument: Argument, activityService: ActivityService) {
        self.onSelect = argument.onSelect
        self.activityService = activityService
    }
    
    
}

// MARK: - Inner types

extension WorkoutActivityPickerViewModel {
    
    struct Argument {
        let onSelect: (Activity) -> Void
    }
    
}

// MARK: - Computed values

extension WorkoutActivityPickerViewModel {
    
    var activities: [Activity] {
        return activityService.defaultActivities
    }
    
}

// MARK: - Logic

extension WorkoutActivityPickerViewModel {
    
    func select(_ activity: Activity) -> () -> Void {
        return { [unowned self] in
            self.onSelect(activity)
            self.dismiss()
        }
    }
    
}
