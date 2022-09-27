//Created by Alexander Skorulis on 27/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct AddEntryView {
    @StateObject var viewModel: AddEntryViewModel
}

// MARK: - Rendering

extension AddEntryView: View {
    
    var body: some View {
        EmptyView()
    }
}

// MARK: - Previews

struct AddEntryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let example = Activity(name: "Pull up", measureTypes: [.reps])
        AddEntryView(viewModel: ioc.resolve(AddEntryViewModel.self, argument: example))
    }
}

