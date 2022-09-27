//Created by Alexander Skorulis on 14/9/2022.

import Foundation
import SwiftUI
import ASSwiftUI

// MARK: - Memory footprint

public struct PageTemplate<Nav: View, Content: View> {
    
    private let nav: () -> Nav
    private let content: () -> Content
    
    public init(nav: @escaping () -> Nav, content: @escaping () -> Content) {
        self.nav = nav
        self.content = content
    }
    
}

// MARK: - Rendering

extension PageTemplate: View {
    
    public var body: some View {
        VStack(spacing: 0) {
            nav()
            ScrollView {
                Spacer()
                    .frame(height: 12)
                content()
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Previews

struct PageTemplate_Previews: PreviewProvider {
    
    static var previews: some View {
        PageTemplate {
            NavBar(left: BarButtonItem.back({}))
        } content: {
            Text("TEst")
        }

    }
}


