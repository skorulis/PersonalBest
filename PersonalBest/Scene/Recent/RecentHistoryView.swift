//Created by Alexander Skorulis on 29/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RecentHistoryView {
    
    @StateObject var viewModel: RecentHistoryViewModel
}

// MARK: - Rendering

extension RecentHistoryView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() ->some View {
        NavBar(mid: BarButtonItem.title("Records"))
    }
    
    private func content() -> some View {
        VStack {
            ForEach(viewModel.records) { item in
                Button(action: viewModel.show(activity: item.activity)) {
                    row(item)
                }
            }
        }
    }
    
    private func row(_ data: RecentEntry) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.activity.name)
                Text(DateFormatter.mediumDate.string(from: data.value.date))
            }
            Spacer()
            VStack(alignment: .leading) {
                RecordValueDisplay(value: data.value.value, unit: data.value.unit)
            }
            
        }
        
    }
}

// MARK: - Previews

struct RecentHistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        RecentHistoryView(viewModel: ioc.resolve())
    }
}

