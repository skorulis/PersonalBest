//Created by Alexander Skorulis on 29/9/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct SettingsView {
    
    @StateObject var viewModel: SettingsViewModel
}

// MARK: - Rendering

extension SettingsView: View {
    
    var body: some View {
        VStack {
            Text("TODO")
        }
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        SettingsView(viewModel: ioc.resolve())
    }
}

