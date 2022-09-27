//  Created by Alexander Skorulis on 26/9/2022.

import ASKCore
import Foundation
import Swinject
import SwinjectAutoregistration

public final class IOC: IOCService {
    
    override init(purpose: IOCPurpose = .testing) {
        super.init(purpose: purpose)
        setupServices()
        setupViewModels()
        registerStores()
    }
    
    private func setupServices() {
        container.autoregister(UnitService.self, initializer: UnitService.init)
            .inObjectScope(.container)
        container.autoregister(ActivityService.self, initializer: ActivityService.init)
    }
    
    private func registerStores() {
        container.autoregister(RecordsStore.self, initializer: RecordsStore.init)
            .inObjectScope(.container)
    }
    
    private func setupViewModels() {
        container.autoregister(ContentViewModel.self, initializer: ContentViewModel.init)
        container.autoregister(ActivityListViewModel.self, initializer: ActivityListViewModel.init)
    }
}
