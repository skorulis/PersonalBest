//Created by Alexander Skorulis on 2/11/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct NewVariationView {
    @StateObject var viewModel: NewVariationViewModel
}

// MARK: - Rendering

extension NewVariationView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: .back(viewModel.back),
               mid: .title("New Variant")
        )
    }
    
    private func content() -> some View {
        VStack {
            TextField("Variant name", text: $viewModel.text)
                .textFieldStyle(.roundedBorder)
            
            Button(action: viewModel.save) {
                Text("Save")
            }
            .buttonStyle(ShadowButtonStyle())
        }
        .padding(.horizontal, 16)
    }
}

#if DEBUG

// MARK: - Previews

struct NewVariationView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let ctx = ioc.resolve(CoreDataStore.self).mainContext
        let activity = PreviewData.bodyActivity(ctx)
        let viewModel = ioc.resolve(NewVariationViewModel.self, argument: activity)
        return NewVariationView(viewModel: viewModel)
    }
}


#endif
