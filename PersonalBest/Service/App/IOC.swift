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
        registerAccess()
        
        self.resolve(ActivityService.self).setupSystemData()
    }
    
    private func setupServices() {
        container.autoregister(UnitService.self, initializer: UnitService.init)
            .inObjectScope(.container)
        container.autoregister(ActivityService.self, initializer: ActivityService.init)
        container.autoregister(GraphDataGenerator.self, initializer: GraphDataGenerator.init)
    }
    
    private func registerStores() {
        switch purpose {
        case .testing:
            container.autoregister(PKeyValueStore.self, initializer: InMemoryDefaults.init)
                .inObjectScope(.container)
        case .normal:
            container.autoregister(PKeyValueStore.self, initializer: UserDefaults.init)
                .inObjectScope(.container)
        }
        
        switch purpose {
        case .testing:
            container.autoregister(CoreDataStore.self, initializer: CoreDataStore.previews)
                .inObjectScope(.container)
        case .normal:
            container.autoregister(CoreDataStore.self, initializer: CoreDataStore.database)
                .inObjectScope(.container)
        }
        
        container.autoregister(RecordsStore.self, initializer: RecordsStore.init)
            .inObjectScope(.container)
    }
    
    private func registerAccess() {
        container.autoregister(RecordEntryAccess.self, initializer: RecordEntryAccess.init)
    }
    
    private func setupViewModels() {
        container.autoregister(ContentViewModel.self, initializer: ContentViewModel.init)
        container.autoregister(ActivityDetailsViewModel.self, argument: PBActivity.self, initializer: ActivityDetailsViewModel.init)
        container.autoregister(AddEntryViewModel.self, argument: PBActivity.self, initializer: AddEntryViewModel.init)
        
        container.autoregister(CategoryListViewModel.self, initializer: CategoryListViewModel.init)
        container.autoregister(CategoryActivitiesViewModel.self,
                               argument: PBCategory.self,
                               initializer: CategoryActivitiesViewModel.init)
        
        container.autoregister(RecentHistoryViewModel.self, initializer: RecentHistoryViewModel.init)
        
        container.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
        
        container.autoregister(WorkoutListViewModel.self, initializer: WorkoutListViewModel.init)
        container.autoregister(WorkoutDetailsViewModel.self,
                               argument: PBWorkout.self,
                               initializer: WorkoutDetailsViewModel.init)
        
        container.autoregister(WorkoutActivityPickerViewModel.self,
                               argument: WorkoutActivityPickerViewModel.Argument.self,
                               initializer: WorkoutActivityPickerViewModel.init)
        
        container.autoregister(VariationListViewModel.self,
                               argument: VariationListViewModel.Argument.self,
                               initializer: VariationListViewModel.init)
        
        
        
    }
}
