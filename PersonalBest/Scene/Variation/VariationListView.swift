//Created by Alexander Skorulis on 6/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct VariationListView {
    
    @StateObject var viewModel: VariationListViewModel
    
}

// MARK: - Rendering

extension VariationListView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: BarButtonItem.back(viewModel.back),
               mid: BarButtonItem.title("Variations"),
               right: BarButtonItem.iconButton(Image(systemName: "plus"), viewModel.newOption)
        )
    }
    
    private func content() -> some View {
        VStack {
            cell(variant: nil)
            ForEach(viewModel.activity.orderedVariations) { variant in
                cell(variant: variant)
            }
        }
        .id(viewModel.activity.variantsID)
    }
    
    private func cell(variant: PBVariant?) -> some View {
        Button(action: {viewModel.select(variant) } ) {
            Text(variant?.name ?? "None")
        }
    }
}

// MARK: - Previews

struct VariationListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let example = PBActivity(context: context)
        example.name = "Pullup"
        example.trackingType = .reps
        
        let v1 = PBVariant(context: context)
        v1.name = "Wide grip"
        v1.activity = example
        
        let arg = VariationListViewModel.Argument(activity: example, onSelect: {_ in })
        
        return VariationListView(viewModel: ioc.resolve(VariationListViewModel.self, argument: arg))
    }
}

