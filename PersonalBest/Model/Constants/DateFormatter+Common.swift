//Created by Alexander Skorulis on 29/9/2022.

import Foundation

extension DateFormatter {
    
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
}
