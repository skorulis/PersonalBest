//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import SwiftUI
import ASSwiftUI

// MARK: - Memory footprint

struct ActivityListView {
    
    @StateObject var viewModel: ActivityListViewModel
}

// MARK: - Rendering

extension ActivityListView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        return NavBar(left: BarButtonItem.back(viewModel.back),
                      mid: BarButtonItem.title("Activities"),
                      right: BarButtonItem.iconButton(Image(systemName: "plus"), viewModel.add)
        )
    }
    
    private func content() -> some View {
        LazyVStack {
            ForEach(viewModel.activities) { activity in
                Button(action: viewModel.show(activity: activity)) {
                    ActivityCell(activity: activity)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Previews

struct ActivityListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        ActivityListView(viewModel: ioc.resolve())
    }
}

