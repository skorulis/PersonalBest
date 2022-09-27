//Created by Alexander Skorulis on 27/9/2022.

import Foundation

// MARK: - Memory footprint

final class ActivityDetailsViewModel: CoordinatedViewModel, ObservableObject {
    
    let activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
        super.init()
    }
    
}

// MARK: - Logic

extension ActivityDetailsViewModel {
    
    func addEntry() {
        let path = RootPath.addEntry(activity)
        coordinator.present(path, style: .sheet)
    }
    
}
