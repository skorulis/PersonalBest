//Created by Alexander Skorulis on 27/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ActivityDetailsView {
    
    @StateObject var viewModel: ActivityDetailsViewModel
    
}

// MARK: - Rendering

extension ActivityDetailsView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: BarButtonItem.back(viewModel.back),
               mid: BarButtonItem.title(viewModel.activity.name)
        )
    }
    
    private func content() -> some View {
        VStack {
            newEntry
            
            // TODO: Graph
            
            // TODO: List entry
        }
    }
    
    private var newEntry: some View {
        Button(action: viewModel.addEntry) {
            Text("Add Entry")
        }
    }
}

// MARK: - Previews

struct ActivityDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let example = Activity(name: "Pull up", measureTypes: [.reps])
        return ActivityDetailsView(viewModel: ioc.resolve(ActivityDetailsViewModel.self, argument: example))
    }
}

