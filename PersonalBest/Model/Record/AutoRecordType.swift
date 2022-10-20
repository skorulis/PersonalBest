//Created by Alexander Skorulis on 16/10/2022.

import Foundation

enum AutoRecordType: String {
    /// A record representing total volume for an activity
    case volume
    
    var displayText: String {
        switch self {
        case .volume:
            return "Volume"
        }
    }
}
