//Created by Alexander Skorulis on 2/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct WorkoutActivityPickerView {
    
    @StateObject var viewModel: WorkoutActivityPickerViewModel
    
}

// MARK: - Rendering

extension WorkoutActivityPickerView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(left: EmptyView(),
               mid: BarButtonItem.title("Activities"),
               right: BarButtonItem.close(viewModel.dismiss)
        )
    }
    
    private func content() -> some View {
        VStack {
            ForEach(viewModel.activities) { activity in
                Button(action: viewModel.select(activity)) {
                    //ActivityCell(activity: activity)
                    Text("TEST")
                }
            }
        }
    }
}

// MARK: - Previews

struct WorkoutActivityPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let arg = WorkoutActivityPickerViewModel.Argument(onSelect: {_ in })
        return WorkoutActivityPickerView(viewModel: ioc.resolve(WorkoutActivityPickerViewModel.self, argument: arg))
    }
}

