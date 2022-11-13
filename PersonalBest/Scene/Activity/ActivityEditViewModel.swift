//Created by Alexander Skorulis on 13/11/2022.

import ASKCore
import Foundation

final class ActivityEditViewModel: CoordinatedViewModel, ObservableObject {
    
    private let errorService: PErrorService
    private let coreDataService: CoreDataStore
    private let onSave: ((PBActivity) -> Void)?
    let categories: [PBCategory]
    
    @Published var name: String = ""
    @Published var trackingType: ActivityTrackingType = .reps
    @Published var category: PBCategory
    
    init(argument: Argument,
         errorService: PErrorService,
         coreDataService: CoreDataStore
    ) {
        self.onSave = argument.onSave
        self.errorService = errorService
        self.coreDataService = coreDataService
        self.categories = try! coreDataService.mainContext.fetch(PBCategory.fetch())
        self.category = categories.first!
    }
    
}

// MARK: - Logic

extension ActivityEditViewModel {
    
    func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        let fetch = PBActivity.fetch()
        fetch.predicate = NSPredicate(format: "name == [cd] %@", trimmedName)
        let context = coreDataService.mainContext
        guard try! context.fetch(fetch).isEmpty else {
            errorService.handle(error: ErrorType.usedName(trimmedName))
            return
        }
        
        let activity = PBActivity.new(context: context, name: name, tracking: trackingType)
        activity.category = category
        do {
            try context.save()
            coordinator.pop()
        } catch {
            errorService.handle(error: error)
        }
    }
}

// MARK: - Inner types

extension ActivityEditViewModel {
    
    struct Argument {
        let onSave: ((PBActivity) -> Void)?
    }
    
    enum ErrorType: Error, LocalizedError {
        
        case usedName(String)
        
        var errorDescription: String? {
            switch self {
            case .usedName(let name):
                return "There is already an activity named \(name)"
            }
        }
        
    }
    
}
