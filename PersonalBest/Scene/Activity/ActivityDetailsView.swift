//Created by Alexander Skorulis on 27/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI
import Charts

// MARK: - Memory footprint

struct ActivityDetailsView {
    
    @StateObject var viewModel: ActivityDetailsViewModel
    @State private var iconAnimating = false
    
    @FetchRequest var records: FetchedResults<PBRecordEntry>
    
    init(viewModel: ActivityDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _records = FetchRequest<PBRecordEntry>(sortDescriptors: [.init(key: "date", ascending: false)], predicate: NSPredicate(format: "activity == %@", viewModel.activity))
    }
    
}

// MARK: - Rendering

extension ActivityDetailsView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            nav()
            content()
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
    
    private func nav() -> some View {
        NavBar(left: BarButtonItem.back(viewModel.close),
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
            if let top = viewModel.recordBreakdown.highestValue(variant: PBVariant.none) {
                topRecord(top)
            } else {
                Text("No records logged")
            }
            maybeVariantPicker
            newEntry
            unitEdit
        }
        .frame(maxWidth: .infinity)
    }
    
    private func topRecord(_ value: TopRecord) -> some View {
        VStack {
            // image
            
            RecordValueHighlight(value: value)
        }
        .padding(.top, 40)
    }
    
    private var image: some View {
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
    private var maybeVariantPicker: some View {
        if viewModel.recordBreakdown.variants.count > 1 {
            Picker("Variant", selection: $viewModel.variant) {
                ForEach(viewModel.recordBreakdown.variants, id: \.self) { variant in
                    Text(variant)
                        .tag(variant)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    @ViewBuilder
    private var chartOrList: some View {
        switch viewModel.displayType {
        case .chart:
            if let lines = viewModel.lines {
                chartView(lines: lines)
            } else {
                Text("Insufficient data")
            }
        case .list:
            historyList
        }
    }
    
    private func chartView(lines: [GraphLine]) -> some View {
        Chart {
            ForEach(lines) { line in
                lineContent(entries: line)
            }
        }
        .frame(height: 400)
    }
    
    private func lineContent(entries: GraphLine) -> some ChartContent {
        ForEach(entries.entries) { entry in
            LineMark(x: .value("Date", entry.date) ,
                     y: .value(entries.name,  entry.value)
            )
        }
        .foregroundStyle(by: .value("Name", entries.name))
        .foregroundStyle(entries.color)
        .lineStyle(StrokeStyle(lineWidth: 3))
    }
    
    private var historyList: some View {
        ForEach(Array(records.indices), id: \.self) { index in
            let entry = records[index]
            ActivityEntryCell(entry: entry)
        }
        .onDelete(perform: delete(indexSet:))
        .id(viewModel.activity.unitSelectionID)
    }
    
    private var newEntry: some View {
        Button(action: viewModel.addEntry) {
            Text("New personal best")
        }
        .buttonStyle(ShadowButtonStyle())
        .padding(.vertical, 20)
    }
    
    @ViewBuilder
    private var unitEdit: some View {
        if !viewModel.editableUnits.isEmpty {
            VStack {
                ForEach(viewModel.editableUnits) { measurement in
                    Picker(measurement.name, selection: viewModel.unitTypeBinding(measurement)) {
                        ForEach(measurement.unitOptions) { unit in
                            Text(unit.symbolString)
                                .tag(unit)
                        }
                    }
                }
            }
        }
        
    }
    
    private var iconAnimation: Animation {
        Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
    }
}

// MARK: - Logic

extension ActivityDetailsView {
    
    func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            let entry = self.records[index]
            entry.managedObjectContext?.delete(entry)
        }
    }
}

// MARK: - Previews

struct ActivityDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let example = PBActivity.new(context: context, name: "Pull up", tracking: .reps)
        _ = PBRecordEntry.new(activity: example, date: Date(), values: [.reps: 20])
        _ = PBRecordEntry.new(activity: example, date: Date().advanced(by: 2200000), values: [.reps: 22])
        
        let argument = ActivityDetailsViewModel.Argument(activity: example, customDismiss: nil)

        return ActivityDetailsView(viewModel: ioc.resolve(ActivityDetailsViewModel.self, argument: argument))
    }
}

