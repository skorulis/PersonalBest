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
        ListTemplate(nav: nav, content: content)
    }
    
    private func nav() ->some View {
        NavBar(mid: BarButtonItem.title("Records"))
            .alert("Delete all \(viewModel.toDelete?.name ?? "") records?",
                   isPresented: viewModel.alertShowingBinding,
                   presenting: viewModel.toDelete) { activity in
                Button("Delete", role: .destructive) { viewModel.confirmDelete(activity: activity) }
                Button("Cancel", role: .cancel) { }
            }
    }
    
    private func content() -> some View {
        ForEach(recentActivities) { activity in
            Button(action: viewModel.show(activity: activity)) {
                row(activity)
            }
            .swipeActions(allowsFullSwipe: false) {
                Button(action: viewModel.deleteAction(activity: activity)) {
                    Text("Delete")
                }
                .tint(.red)
            }
        }
    }
    
    private func row(_ activity: PBActivity) -> some View {
        let recent = viewModel.entry(activity: activity)
        return HStack {
            VStack(alignment: .leading) {
                Text(activity.name)
                    .multilineTextAlignment(.leading)
                    .font(.title)
                Text(DateFormatter.mediumDate.string(from: recent.value.date))
            }
            Spacer()
            VStack(alignment: .leading) {
                RecordValueDisplay(value: recent.value.value, unit: recent.value.unit)
            }
        }
        .foregroundColor(.primary)
        
    }
}

// MARK: - Previews

struct RecentHistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        let example = PBActivity()
        example.name = "Bench press"
        example.trackingType = .weightlifting
        //recordsStore.add(entry: .init(date: Date(), values: [.weight: 10, .reps: 10]), activity: activity)
        
        return RecentHistoryView(viewModel: ioc.resolve())
    }
}

