//Created by Alexander Skorulis on 6/10/2022.

import ASKCore
import Foundation

// MARK: - Memory footprint

final class VariationListViewModel: CoordinatedViewModel, ObservableObject {
 
    let activity: PBActivity
    private let onSelect: (PBVariant?) -> Void
    
    init(argument: Argument) {
        self.activity = argument.activity
        self.onSelect = argument.onSelect
        super.init()
        
        activity.objectWillChange.sink { [unowned self] _ in
            self.objectWillChange.send()
        }
        .store(in: &subscribers)
    }
    
}

// MARK: - Inner types

extension VariationListViewModel {
    
    struct Argument {
        let activity: PBActivity
        let onSelect: (PBVariant?) -> Void
    }
    
}

// MARK: - Logic

extension VariationListViewModel {
    
    func select(_ variant: PBVariant?) {
        onSelect(variant)
        back()
    }
    
    func newOption() {
        let path = RootPath.newVariant(activity)
        coordinator.push(path)
    }
    
}
