//Created by Alexander Skorulis on 27/9/2022.

import Combine
import Foundation
import SwiftUI
import ASKCore

protocol PCoordinatedViewModel: AnyObject {
    var coordinator: MainCoordinator! {get set}
    var subscribers: Set<AnyCancellable> {get set}
}

class CoordinatedViewModel: PCoordinatedViewModel {
    weak var coordinator: MainCoordinator! {
        didSet {
            onCoordinatorSet()
        }
    }
    var subscribers: Set<AnyCancellable> = []
    
    func back() {
        coordinator.pop()
    }
    
    func dismiss() {
        coordinator.shouldDismiss = true
    }
    
    func onCoordinatorSet() { /* Overridden in children */ }
    
}

final class MainCoordinator: PCoordinator, ObservableObject {
    typealias PathType = RootPath
    
    @Published var navPath = NavigationPath()
    @Published var presented: PresentedCoordinator<MainCoordinator>?
    @Published var shouldDismiss: Bool = false
    let root: PathType
    let factory: PFactory
    
    init(root: PathType, factory: PFactory) {
        self.root = root
        self.factory = factory
    }
    
    func child(path: RootPath) -> MainCoordinator {
        return MainCoordinator(root: path, factory: factory)
    }
    
}

extension MainCoordinator: PFactory {
    
    func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        let obj = factory.resolve(serviceType, argument: argument)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        let obj = factory.resolve(serviceType, arguments: arg1, arg2)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        let obj = factory.resolve(serviceType)
        (obj as? CoordinatedViewModel)?.coordinator = self
        return obj
    }
    
}
