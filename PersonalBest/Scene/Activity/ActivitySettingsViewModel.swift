//Created by Alexander Skorulis on 4/3/2023.

import Foundation
import SwiftUI

final class ActivitySettingsViewModel: ObservableObject {
    
    let activity: PBActivity
    
    init(activity: PBActivity) {
        self.activity = activity
    }
    
}

// MARK: - Logic

extension ActivitySettingsViewModel {
    var editableUnits: [MeasurementType] {
        return activity.editableUnits
    }
    
    func unitTypeBinding(_ measurement: MeasurementType) -> Binding<KnownUnit> {
        return Binding<KnownUnit> { [unowned self] in
            return self.activity.currentUnit(measurement)
        } set: { newValue in
            self.activity.units[measurement] = newValue
            self.save()
            self.objectWillChange.send()
        }
    }
    
    func save() {
        try! self.activity.managedObjectContext?.save()
    }
}
