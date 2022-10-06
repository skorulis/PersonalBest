//Created by Alexander Skorulis on 7/10/2022.

import ASSwiftUI
import Foundation
import SwiftUI

enum FontName: String, PFontEnum {
    
    case light = "Figtree-Light"
    case medium = "Figtree-Medium"
    case bold = "Figtree-Bold"
    
    public func font(_ size: CGFloat) -> Font {
        _ = FontName.registerFontsOnce
        return Font.custom(rawValue, size: size)
    }
    
    var ext: String {
        return "ttf"
    }
    
    var name: String { rawValue }
    
}

private extension FontName {
    
    private static let registerFontsOnce: () = {
        _ = UIFont.familyNames
        
        for font in allCases {
            Bundle.main.registerFont(name: font.rawValue, ext: font.ext)
        }
    }()
    
}
