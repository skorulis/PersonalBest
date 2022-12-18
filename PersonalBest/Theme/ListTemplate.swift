//Created by Alexander Skorulis on 2/10/2022.

import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

public struct ListTemplate<Nav: View, Content: View> {
    
    private let nav: () -> Nav
    private let content: () -> Content
    
    public init(nav: @escaping () -> Nav, content: @escaping () -> Content) {
        self.nav = nav
        self.content = content
    }
    
}

// MARK: - Rendering

extension ListTemplate: View {
    
    public var body: some View {
        VStack(spacing: 0) {
            nav()
            List {
                content()
            }
            .listStyle(.plain)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Previews

struct ListTemplate_Previews: PreviewProvider {
    
    static var previews: some View {
        ListTemplate {
            NavBar(left: NavBarItem.back({}))
        } content: {
            Text("TEst")
        }

    }
}



