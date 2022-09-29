//  Created by Alexander Skorulis on 26/9/2022.

import SwiftUI
import ASKCore

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel
    @Environment(\.factory) private var factory
    
    var body: some View {
        mainTabs
    }
    
    var mainTabs: some View {
        TabView {
            recentTab
            activityTab
            settingsTab
        }
    }
    
    var recentTab: some View {
        CoordinatorView(coordinator: MainCoordinator(root: .recent, factory: factory))
            .tabItem {
                Text("Recent")
                Image(systemName: "clock.fill")
            }
    }
    
    var activityTab: some View {
        CoordinatorView(coordinator: MainCoordinator(root: .activity, factory: factory))
            .tabItem {
                Text("Activity")
                Image(systemName: "list.bullet")
            }
    }
    
    var settingsTab: some View {
        CoordinatorView(coordinator: MainCoordinator(root: .settings, factory: factory))
            .tabItem {
                Text("Settings")
                Image(systemName: "gearshape.fill")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let ioc = IOC()
        ContentView(viewModel: ioc.resolve())
    }
}
