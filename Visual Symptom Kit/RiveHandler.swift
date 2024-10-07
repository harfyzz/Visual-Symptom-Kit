//
//  RiveHandler.swift
//  Visual Symptom Kit
//
//  Created by Afeez Yunus on 06/10/2024.
//

import SwiftUI
import RiveRuntime

class BodyViewModel: RiveViewModel {
    @Published var zoomState = ""
    @Published var musclePart = ""// This will update your text based on the event value

    init() {
        super.init(fileName: "muscle_division", stateMachineName: "State Machine 1")
    }
    
    func view() -> some View {
        super.view().frame(width: 400, height: 400, alignment: .center)
    }
    // Subscribe to Rive events
    @objc func onRiveEventReceived(onRiveEvent riveEvent: RiveEvent) {
        if let generalEvent = riveEvent as? RiveGeneralEvent {
            let eventProperties = generalEvent.properties()
            
            // Assuming the event has a property like "roomNumber"
            if let zoomLevel = eventProperties["CTRL"] as? String {
                zoomState = "\(zoomLevel)"  // Update the room number from 1 to 7
            }
            if let bodyPart = eventProperties["Body part"] as? String {
                musclePart  = "\(bodyPart)"  // Update the room number from 1 to 7
            }
            
        }
        
    }
    

    
}
