//  Created by Alexander Skorulis on 26/9/2022.

import ASKCore
import Foundation
import Swinject
import SwinjectAutoregistration

public final class IOC: IOCService {
    
    override init(purpose: IOCPurpose = .testing) {
        super.init(purpose: purpose)
        registerServices()
        registerViewModels()
        registerStores()
        registerAccess()
        
        self.resolve(ActivityService.self).setupSystemData()
    }
    
    private func registerServices() {
        container.autoregister(UnitService.self, initializer: UnitService.init)
            .inObjectScope(.container)
        container.autoregister(ActivityService.self, initializer: ActivityService.init)
        container.autoregister(GraphDataGenerator.self, initializer: GraphDataGenerator.init)
        container.autoregister(BreakdownService.self, initializer: BreakdownService.init)
        container.autoregister(AnalyticsService.self, initializer: AnalyticsService.init)
            .inObjectScope(.container)
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
        
    }
    
    private func registerAccess() {
        container.autoregister(RecordEntryAccess.self, initializer: RecordEntryAccess.init)
    }
    
    private func registerViewModels() {
        container.autoregister(ContentViewModel.self, initializer: ContentViewModel.init)
        container.autoregister(ActivityDetailsViewModel.self,
                               argument: ActivityDetailsViewModel.Argument.self,
                               initializer: ActivityDetailsViewModel.init)
        container.autoregister(ActivitySettingsViewModel.self,
                               argument: PBActivity.self,
                               initializer: ActivitySettingsViewModel.init)
        
        container.autoregister(AddEntryViewModel.self,
                               argument: AddEntryViewModel.Argument.self,
                               initializer: AddEntryViewModel.init)
        
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
        
        container.autoregister(NewVariationViewModel.self,
                               argument: PBActivity.self,
                               initializer: NewVariationViewModel.init)
        
        container.autoregister(ActivityEditViewModel.self,
                               argument: ActivityEditViewModel.Argument.self,
                               initializer: ActivityEditViewModel.init)
        
        
    }
}
