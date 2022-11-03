//Created by Alexander Skorulis on 29/9/2022.

import ASSwiftUI
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
    }
    
    private func nav() ->some View {
        NavBar(mid: BarButtonItem.title("Records"))
            .alert("Delete all \(viewModel.toDelete?.name ?? "") records?",
                   isPresented: viewModel.alertShowingBinding,
                   presenting: viewModel.toDelete) { entry in
                Button("Delete", role: .destructive) { viewModel.confirmDelete(entry: entry) }
                Button("Cancel", role: .cancel) { }
            }
    }
    
    
    private func content() -> some View {
        ForEach(viewModel.collect(activities: recentActivities.reversed())) { entry in
            RecentActivityCell(recent: entry,
                               onPress: viewModel.show)
            .listRowSeparator(.hidden)
            .listRowBackground(EmptyView())
            .swipeActions(allowsFullSwipe: false) {
                Button(action: viewModel.deleteAction(entry: entry)) {
                    Text("Delete")
                }
                .tint(.red)
            }
        }
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

