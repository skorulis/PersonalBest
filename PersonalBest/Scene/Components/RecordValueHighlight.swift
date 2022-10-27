//Created by Alexander Skorulis on 23/10/2022.

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct RecordValueHighlight {
    let value: TopRecord
    let showBorder: Bool
    @State private var textSize: CGSize = .zero
    @State private var isAnimating: Bool = false
    
    private static let textPadding: CGFloat = 18
}

// MARK: - Rendering

extension RecordValueHighlight: View {
    
    var body: some View {
        text
            .readSize(size: $textSize)
            .frame(minHeight: textSize.width)
            .padding(Self.textPadding)
        .background(maybeBackground)
    }
    
    @ViewBuilder
    private var maybeBackground: some View {
        if textSize.width > 0 {
            if showBorder {
                fullBackground
            } else {
                middleCircle
            }
        }
    }
    
    private var fullBackground: some View {
        Image("medal-background")
            .resizable()
            .scaleEffect(isAnimating ? 1.4: 1.2)
            .animation(animation, value: isAnimating)
            
            .overlay(middleCircle)
            .onAppear {
                self.isAnimating = true
            }
    }
    
    private var middleCircle: some View {
        ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .stroke(Color.orange, lineWidth: 6)
        }
    }
    
    private var text: some View {
        VStack {
            RecordValueDisplay(value: value.value, unit: value.unit)
            if showBorder {
                // Text(DateFormatter.mediumDate.string(from: value.date))
            }
        }
    }
    
    private var animation: Animation {
        return .linear(duration: 0.7).repeatForever(autoreverses: true)
    }
    
}

// MARK: - Previews

struct RecordValueHighlight_Previews: PreviewProvider {
    
    static var previews: some View {
        let top = TopRecord(date: Date(), value: 100, unit: .reps)
        VStack {
            RecordValueHighlight(value: top, showBorder: true)
            
            RecordValueHighlight(value: top, showBorder: false)
                .background(
                    Rectangle()
                        .stroke(Color.black)
                )
        }
        
    }
}

