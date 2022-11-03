//Created by Alexander Skorulis on 2/11/2022.

import ASKCore
import Foundation

final class NewVariationViewModel: CoordinatedViewModel, ObservableObject {
    
    private let activity: PBActivity
    private let errorService: PErrorService
    
    @Published var text: String = ""
    
    init(activity: PBActivity,
         errorService: PErrorService
    ) {
        self.activity = activity
        self.errorService = errorService
    }
    
    func save() {
        guard text.caseInsensitiveCompare(PBVariant.none) != .orderedSame ||
                PBVariant.find(activity: activity, name: text) == nil else {
            errorService.handle(error: CommonError.generic("\(text) is already a variant for \(activity.name)"))
            return
        }
        
        let variant = PBVariant.new(activity: activity, name: text)
        try! variant.managedObjectContext!.save()
        
        coordinator.pop()
    }
    
}

