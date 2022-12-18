//Created by Alexander Skorulis on 4/10/2022.

import ASKCore
import ASKDesignSystem
import Foundation
import SwiftUI

// MARK: - Memory footprint

/// A field of entering time values
struct TimeField {
    
    @Binding var value: Double?
    
    @State private var hoursText: String
    @State private var minutesText: String
    @State private var secondsText: String
    
    init(value: Binding<Double?>) {
        _value = value
        let breakdown = TimeBreakdown(seconds: value.wrappedValue ?? 0)
        if breakdown.seconds > 0 {
            _secondsText = State(wrappedValue: "\(breakdown.seconds)")
        } else {
            _secondsText = State(wrappedValue: "")
        }
        
        if breakdown.minutes > 0 {
            _minutesText = State(wrappedValue: "\(breakdown.minutes)")
        } else {
            _minutesText = State(wrappedValue: "")
        }
        
        if breakdown.hours > 0 {
            _hoursText = State(wrappedValue: "\(breakdown.hours)")
        } else {
            _hoursText = State(wrappedValue: "")
        }
    }
    
}

// MARK: - Rendering

extension TimeField: View {
    
    var body: some View {
        HStack {
            TextField("Hours", text: $hoursText)
            TextField("Minutes", text: $minutesText)
            TextField("Seconds", text: $secondsText)
        }
        .onChange(of: hoursText) { _ in
            valueChanged()
        }
        .onChange(of: secondsText) { _ in
            valueChanged()
        }
        .onChange(of: minutesText) { _ in
            valueChanged()
        }
    }
    
    func valueChanged() {
        var totalSeconds: Double = 0
        if let seconds = Double(secondsText) {
            totalSeconds += seconds
        }
        if let minutes = Int(minutesText) {
            totalSeconds += Double(minutes) * 60
        }
        if let hours = Int(hoursText) {
            totalSeconds += Double(hours) * 60
        }
        
        self.value = totalSeconds
    }
}

// MARK: - Inner types

struct TimeBreakdown {
    
    let seconds: Double
    let minutes: Int
    let hours: Int
    
    init(seconds: Double) {
        var remaining = seconds
        self.hours = Int(remaining) / 3600
        remaining -= Double(self.hours) * 3600
        self.minutes = Int(remaining) / 60
        remaining -= Double(self.minutes) * 60
        self.seconds = remaining
    }
}

// MARK: - Previews

struct TimeField_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            StatefulPreviewWrapper(Double(0)) { value in
                TimeField(value: value)
            }
            
            StatefulPreviewWrapper(Double(100)) { value in
                TimeField(value: value)
            }
        }
        
    }
}

