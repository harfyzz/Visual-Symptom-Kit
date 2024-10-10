//
//  Model.swift
//  Visual Symptom Kit
//
//  Created by Afeez Yunus on 06/10/2024.
//

import Foundation

// Model for Body Parts
struct BodyParts: Codable {
    let Front1: [String]
    let Front2a: [String]
    let Front2b: [String]
    let Front2c: [String]
    let Front3a: [String]
    let Front3b: [String]
    let Front4: [String]
    let Back1: [String]
    let Back2a: [String]
    let Back2b: [String]
    let Back2c: [String]
    let Back3a: [String]
    let Back3b: [String]
    let Back4: [String]
 
}

// Container for the entire body parts object
struct BodyPartsData: Codable {
    let bodyParts: BodyParts
    
    enum CodingKeys: String, CodingKey {
        case bodyParts = "bodyParts"
    }
}


struct PainType {
    let painType: [String] = ["Stabbing","Throbbing", "Achy", "Pinching", "Burning", "Sharp", "Shooting", "Radiating", "Cramping", "Deep", "Superficial", "Other"]
}

struct PainSession:Identifiable {
    let id = UUID()
    var painPart:String = ""
    var painTypes:[String] = []
    var painSeverity:String = ""
    var painDescription:String = ""
}
