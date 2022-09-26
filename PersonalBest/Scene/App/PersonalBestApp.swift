//  Created by Alexander Skorulis on 26/9/2022.

import ASKCore
import SwiftUI

@main
struct PersonalBestApp: App {
    
    private let ioc = IOC(purpose: .normal)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.factory, ioc)
        }
    }
}
