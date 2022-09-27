//Created by Alexander Skorulis on 27/9/2022.

import Foundation
import ASKCore
import Foundation
import SwiftUI

enum RootPath: CoordinatorPath, Hashable {
    
    case activity
    
    @ViewBuilder
    func render(coordinator: MainCoordinator) -> some View {
        switch self {
        case .activity:
            ActivityListView(viewModel: coordinator.resolve())
        }
    }
    
}
