//Created by Alexander Skorulis on 30/9/2022.

import ASSwiftUI
import Foundation
import SwiftUI

// MARK: - Memory footprint

struct CategoryListView {
    
    @StateObject var viewModel: CategoryListViewModel
}

// MARK: - Rendering

extension CategoryListView: View {
    
    var body: some View {
        PageTemplate(nav: nav, content: content)
    }
    
    private func nav() -> some View {
        NavBar(mid: BarButtonItem.title("Activities"))
    }
    
    private func content() -> some View {
        VStack {
            grid
        }
        .padding(.horizontal, 16)
    }
    
    private var grid2: some View {
        Grid {
            ForEach(viewModel.categoryRows, id: \.0) { row in
                GridRow {
                    categoryCell(label: row.0)
                    categoryCell(label: row.1)
                }
            }
        }
    }
    
    private var grid: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns) {
            ForEach(viewModel.categories, id:\.self) { label in
                categoryCell(label: label)
            }
        }
    }
    
    private func categoryCell(label: String) -> some View {
        Button(action: {viewModel.selected(category: label)}) {
            Text(label)
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

// MARK: - Previews

struct CategoryListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let ioc = IOC()
        return CategoryListView(viewModel: ioc.resolve())
    }
}

