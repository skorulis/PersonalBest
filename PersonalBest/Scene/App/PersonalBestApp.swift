//  Created by Alexander Skorulis on 26/9/2022.

import ASKCore
import SwiftUI

@main
struct PersonalBestApp: App {
    
    private let ioc = IOC(purpose: .normal)
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ioc.resolve())
                .environment(\.factory, ioc)
                .environment(\.managedObjectContext, ioc.resolve(CoreDataStore.self).mainContext)
        }
    }
}
