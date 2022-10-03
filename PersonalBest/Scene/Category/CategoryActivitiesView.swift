//Created by Alexander Skorulis on 30/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct CategoryActivitiesView {
    
    @StateObject var viewModel: CategoryActivitiesViewModel
    
    @FetchRequest var activities: FetchedResults<PBActivity>
    
    init(viewModel: CategoryActivitiesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _activities = FetchRequest<PBActivity>(sortDescriptors: [], predicate: NSPredicate(format: "category == %@", viewModel.category))
        
    }
    
}

// MARK: - Rendering

extension CategoryActivitiesView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        return NavBar(left: BarButtonItem.back(viewModel.back),
                      mid: BarButtonItem.title(viewModel.category.name),
                      right: BarButtonItem.iconButton(Image(systemName: "plus"), viewModel.addActivity)
        )
    }
    
    private func content() -> some View {
        LazyVStack {
            ForEach(activities) { activity in
                Button(action: viewModel.show(activity: activity)) {
                    ActivityCell(activity: activity)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Previews

struct CategoryActivitiesView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let viewModel = ioc.resolve(CategoryActivitiesViewModel.self, argument: SystemCategory.bodyWeight.rawValue)
        return CategoryActivitiesView(viewModel: viewModel)
    }
}

