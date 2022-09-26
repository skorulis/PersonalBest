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
        
    }
    
    private func registerStores() {
        
    }
    
    private func setupViewModels() {
        
    }
}
