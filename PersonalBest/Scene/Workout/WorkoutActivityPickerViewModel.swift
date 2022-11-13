//Created by Alexander Skorulis on 2/10/2022.

import ASKCore
import Foundation

final class WorkoutActivityPickerViewModel: CoordinatedViewModel, ObservableObject {
    
    private let onSelect: (PBActivity) -> Void
    private let activityService: ActivityService
    
    @Published var searchText: String = ""
    
    init(argument: Argument, activityService: ActivityService) {
        self.onSelect = argument.onSelect
        self.activityService = activityService
    }
    
}

// MARK: - Inner types

extension WorkoutActivityPickerViewModel {
    
    struct Argument {
        let onSelect: (PBActivity) -> Void
    }
    
}

// MARK: - Logic

extension WorkoutActivityPickerViewModel {
    
    func select(_ activity: PBActivity) -> () -> Void {
        return { [unowned self] in
            self.onSelect(activity)
            self.dismiss()
        }
    }
    
    func infoPressed(_ activity: PBActivity) {
        let path = RootPath.activityDetails(activity, nil)
        self.coordinator.push(path)
    }
    
    func addRecord() {
        let path = RootPath.editActivity { [unowned self] activity in
            self.onSelect(activity)
            self.dismiss()
        }
        coordinator.push(path)
    }
    
}
