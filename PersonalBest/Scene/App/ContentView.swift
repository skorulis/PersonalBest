//  Created by Alexander Skorulis on 26/9/2022.

import SwiftUI
import ASKCore

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    @Environment(\.factory) private var factory
    
    var body: some View {
        mainTabs
    }
    
    private var mainTabs: some View {
        TabView {
            recentTab
            workoutTab
            activityTab
            // settingsTab
        }
    }
    
    private var recentTab: some View {
        CoordinatorView(coordinator: coordinator(RootPath.recent))
            .tabItem {
                Text("Recent")
                Image(systemName: "clock.fill")
            }
    }
    
    private var activityTab: some View {
        CoordinatorView(coordinator: coordinator(RootPath.categories))
            .tabItem {
                Text("Activity")
                Image(systemName: "list.bullet")
            }
    }
    
    private var workoutTab: some View {
        CoordinatorView(coordinator: coordinator(RootPath.workoutList))
            .tabItem {
                Text("Workouts")
                Image("dumbbell")
            }
    }
    
    private var settingsTab: some View {
        CoordinatorView(coordinator: coordinator(RootPath.settings))
            .tabItem {
                Text("Settings")
                Image(systemName: "gearshape.fill")
            }
    }
    
    private func coordinator(_ path: any CoordinatorPath) -> StandardCoordinator {
        let coordinator = StandardCoordinator(root: path, factory: factory)
        coordinator.analytics = factory.resolve(AnalyticsService.self)
        return coordinator
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let ioc = IOC()
        return ContentView(viewModel: ioc.resolve())
    }
}
