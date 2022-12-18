//Created by Alexander Skorulis on 27/11/2022.

import Amplitude
import ASKCore
import Foundation

final class AnalyticsService: PAnalyticsService {
    
    init() { }
    
    func startup() {
        Amplitude.instance().trackingSessionEvents = true
        Amplitude.instance().initializeApiKey("f5c4259872513472dd2c55a5d0932fc6")
    }
    
    func log(event: String) {
        Amplitude.instance().logEvent(event)
    }
    
    func log(event: PAnalyticsEvent) {
        Amplitude.instance().logEvent(event.name, withEventProperties: event.properties)
    }
        
}
