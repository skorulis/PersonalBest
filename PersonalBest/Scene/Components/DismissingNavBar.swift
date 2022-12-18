//Created by Alexander Skorulis on 6/11/2022.

import ASKCore
import ASKDesignSystem
import Foundation
import SwiftUI

/// A navigation bar allows
public struct DismissingNavBar<Mid: View>: View {
    
    private let mid: Mid
    @Environment(\.navigationType) private var navType
    @Environment(\.coordinator) private var coordinator
    
    init(mid: Mid) {
        self.mid = mid
    }
    
    public var body: some View {
        switch navType {
        case .none:
            fatalError("Cannot dismiss without a navType")
        case .present:
            NavBar(mid: mid, right: NavBarItem.close({ coordinator?.shouldDismiss = true }))
        case .push:
            NavBar(left: NavBarItem.back({ coordinator?.pop() }), mid: mid)
        }
    }
    
    
}
