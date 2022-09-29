//Created by Alexander Skorulis on 27/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI
import Charts

// MARK: - Memory footprint

struct ActivityDetailsView {
    
    @StateObject var viewModel: ActivityDetailsViewModel
    @State private var iconAnimating = false
    
}

// MARK: - Rendering

extension ActivityDetailsView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            nav()
            content()
        }
        .navigationBarHidden(true)
    }
    
    private func nav() -> some View {
        NavBar(left: BarButtonItem.back(viewModel.back),
               mid: BarButtonItem.title(viewModel.activity.name)
        )
    }
    
    private func content() -> some View {
        List {
            header
                .listRowSeparator(.hidden)
            
            if viewModel.recordBreakdown.hasData {
                bottomSection
            }
            
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private var header: some View {
        VStack {
            if let top = viewModel.recordBreakdown.highestValue {
                topRecord(top)
            } else {
                Text("No records logged")
            }
            newEntry
        }
        .frame(maxWidth: .infinity)
    }
    
    private func topRecord(_ value: TopRecord) -> some View {
        VStack {
            Image("first-icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
                .padding(.vertical, 30)
                .scaleEffect(iconAnimating ? 1.2 : 1)
                .animation(iconAnimation, value: iconAnimating)
                .onAppear {
                    iconAnimating = true
                }
            RecordValueDisplay(value: value.value, unit: value.unit)
            
            Text(DateFormatter.mediumDate.string(from: value.date))
        }
    }
    
    @ViewBuilder
    private var bottomSection: some View {
        maybePicker
            .listRowSeparator(.hidden)
        chartOrList
    }
    
    @ViewBuilder
    private var maybePicker: some View {
        if viewModel.recordBreakdown.canGraph {
            Picker("Selection", selection: $viewModel.displayType) {
                Text("Chart").tag(ActivityDetailsViewModel.DisplayType.chart)
                Text("List").tag(ActivityDetailsViewModel.DisplayType.list)
            }
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    private var chartOrList: some View {
        switch viewModel.displayType {
        case .chart:
            chartView
        case .list:
            historyList
        }
    }
    
    private var chartView: some View {
        Chart {
            ForEach(viewModel.recordBreakdown.lines) { line in
                lineContent(entries: line)
            }
            
        }
        .frame(height: 400)
    }
    
    private func lineContent(entries: GraphLine) -> some ChartContent {
        ForEach(entries.entries) { entry in
            LineMark(x: .value("Date", entry.date) ,
                     y: .value(entries.name, entry.value)
            )
        }
        .foregroundStyle(by: .value("Name", entries.name))
        .foregroundStyle(entries.color)
        .lineStyle(StrokeStyle(lineWidth: 3))
    }
    
    private var historyList: some View {
        ForEach(viewModel.records.reversed()) { entry in
            ActivityEntryCell(activity: viewModel.activity,
                              entry: entry)
            
        }
        .onDelete(perform: viewModel.delete(indexSet:))
        
        
    }
    
    private var newEntry: some View {
        Button(action: viewModel.addEntry) {
            Text("New personal best")
        }
        .buttonStyle(
            WobbleButtonStyle(backgroundColor: .blue.opacity(0.5))
        )
        .padding(.vertical, 20)
    }
    
    private var iconAnimation: Animation {
        Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
    }
}

// MARK: - Previews

struct ActivityDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let example = Activity(name: "Pull up", measureTypes: [.reps])
        let store = ioc.resolve(RecordsStore.self)
        store.add(entry: .init(date: Date(), values: [.reps: 20]), activity: example)
        
        store.add(entry: .init(date: Date().advanced(by: 2200000), values: [.reps: 22]), activity: example)
        return ActivityDetailsView(viewModel: ioc.resolve(ActivityDetailsViewModel.self, argument: example))
    }
}

