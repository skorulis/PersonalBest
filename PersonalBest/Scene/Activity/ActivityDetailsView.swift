//Created by Alexander Skorulis on 27/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI
import Charts

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
            
            historyList
            
            chart
            
        }
    }
    
    private var chart: some View {
        Chart {
            ForEach(viewModel.recordBreakdown) { line in
                lineContent(entries: line)
            }
        }
        .frame(height: 400)
    }
    
    private func lineContent(entries: RecordEntries) -> some ChartContent {
        ForEach(entries.entries) { entry in
            LineMark(x: .value("Date", entry.date) ,
                     y: .value(entries.name, entry.value)
            )
            .foregroundStyle(.blue)
            .lineStyle(StrokeStyle(lineWidth: 3))
        }
    }
    
    private var historyList: some View {
        LazyVStack {
            ForEach(viewModel.records) { entry in
                ActivityEntryCell(activity: viewModel.activity, entry: entry)
            }
        }
        .padding(.horizontal, 16)
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

