//Created by Alexander Skorulis on 30/9/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct CategoryListView {
    
    @StateObject var viewModel: CategoryListViewModel
    @FetchRequest(sortDescriptors: []) var categories: FetchedResults<PBCategory>
}

// MARK: - Rendering

extension CategoryListView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(mid: NavBarItem.title("Activities"))
    }
    
    private func content() -> some View {
        VStack {
            grid2
        }
        .padding(.horizontal, 16)
    }
    
    private var grid2: some View {
        Grid {
            ForEach(categoryRows, id: \.0) { row in
                GridRow {
                    categoryCell(category: row.0)
                    if let second = row.1 {
                        categoryCell(category: second)
                    }
                }
            }
        }
    }
    
    private func categoryCell(category: PBCategory) -> some View {
        Button(action: {viewModel.selected(category: category)}) {
            Text(category.name)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(20)
                .frame(maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                )
        }
    }
}

// MARK: - Logic

extension CategoryListView {
    
    var categoryRows: [(PBCategory, PBCategory?)] {
        let cats = categories
        var result = [(PBCategory, PBCategory?)]()
        for i in stride(from: 0, to: cats.count, by: 2) {
            let second = i < cats.count - 1 ? cats[i + 1] : nil
            let row = (cats[i], second)
            result.append(row)
        }
        
        return result
    }
    
}

// MARK: - Previews

struct CategoryListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        return CategoryListView(viewModel: ioc.resolve())
    }
}

