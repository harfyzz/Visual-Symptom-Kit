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
    @Published var musclePart = ""

    init() {
        super.init(fileName: "muscle_division", stateMachineName: "State Machine 1", fit:.fitHeight)
    }
    
    func view() -> some View {
        super.view().frame(width: 400, height: 400, alignment: .center)
    }
    // Subscribe to Rive events
    @objc func onRiveEventReceived(onRiveEvent riveEvent: RiveEvent) {
        if let generalEvent = riveEvent as? RiveGeneralEvent {
            let eventProperties = generalEvent.properties()
            
            if let zoomLevel = eventProperties["CTRL"] as? String {
                zoomState = "\(zoomLevel)"
            }
            if let bodyPart = eventProperties["Body part"] as? String {
                musclePart  = "\(bodyPart)"
            }
            
        }
        
    }
    

    
}
