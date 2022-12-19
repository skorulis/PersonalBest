//Created by Alexander Skorulis on 29/9/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RecentHistoryView {
    
    @StateObject var viewModel: RecentHistoryViewModel
    
    @FetchRequest var recentActivities: FetchedResults<PBActivity>
    
    init(viewModel: RecentHistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _recentActivities = FetchRequest<PBActivity>(sortDescriptors: [], predicate: NSPredicate(format: "records.@count > 0"))
    }
}

// MARK: - Rendering

extension RecentHistoryView: View {
    
    var body: some View {
        ZStack {
            ListTemplate(nav: nav, content: content)
            if let overlay = viewModel.overlayPath {
                overlay.render(coordinator: viewModel.coordinator)
                    .zIndex(2)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.overlayPath)
        .alert("Delete all \(viewModel.toDelete?.name ?? "") records?",
               isPresented: viewModel.alertShowingBinding,
               presenting: viewModel.toDelete) { entry in
            Button("Delete", role: .destructive) { viewModel.confirmDelete(entry: entry) }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func nav() ->some View {
        NavBar(mid: NavBarItem.title("Records"),
               right: NavBarItem.iconButton(Image(systemName: "plus"), viewModel.addRecord)
        )
    }
    
    @ViewBuilder
    private func content() -> some View {
        let activities = viewModel.grouped(activities: Array(recentActivities))
        if activities.isEmpty {
            emptyContent
                .listRowSeparator(.hidden)
            
        } else {
            fullContent(activities)
        }
    }
    
    private func fullContent(_ activities: [GroupedEntries]) -> some View {
        ForEach(activities) { entry in
            Section {
                GroupedActivityCell(
                    entries: entry.entries,
                    expanded: viewModel.expandedBinding(entry.activity),
                    onDelete: viewModel.deleteAction,
                    onSelect: viewModel.show,
                    onPress: viewModel.show
                )
            }
            .listRowSeparator(.hidden)
            .listRowBackground(EmptyView())
        }
    }
    
    private var emptyContent: some View {
        VStack {
            Button(action: viewModel.addRecord) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            Text("Add your first record")
                .typography(.body)
                .frame(maxWidth: .infinity)
            
        }
        .padding(.top, 100)
    }
    
}


// MARK: - Previews

struct RecentHistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let context = ioc.resolve(CoreDataStore.self).mainContext
        let category = PBCategory(context: context)
        category.name = "TEST"
        
        let example = PBActivity(context: context)
        example.name = "Bench press"
        example.trackingType = .weightlifting
        example.category = category
        
        let entry = PBRecordEntry.new(activity: example, values: [.reps: 10, .weight: 20])
        
        example.records.insert(entry)
        
        try! context.save()
        
        
        return RecentHistoryView(viewModel: ioc.resolve())
    }
}

