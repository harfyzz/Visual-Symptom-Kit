//
//  Model.swift
//  Visual Symptom Kit
//
//  Created by Afeez Yunus on 06/10/2024.
//

import Foundation

// Model for Body Parts
struct BodyParts: Codable {
    let front1: [String]
    let front2a: [String]
    let front2b: [String]
    let front2c: [String]
    let front3a: [String]
    let front3b: [String]
    let front4: [String]
    let back1: [String]
    let back2a: [String]
    let back2b: [String]
    let back2c: [String]
    let back3a: [String]
    let back3b: [String]
    let back4: [String]
    
    enum CodingKeys: String, CodingKey {
        case front1 = "Front1"
        case front2a = "Front2a"
        case front2b = "Front2b"
        case front2c = "Front2c"
        case front3a = "Front3a"
        case front3b = "Front3b"
        case front4 = "Front4"
        case back1 = "Back1"
        case back2a = "Back2a"
        case back2b = "Back2b"
        case back2c = "Back2c"
        case back3a = "Back3a"
        case back3b = "Back3b"
        case back4 = "Back4"
    }
}

// Container for the entire body parts object
struct BodyPartsData: Codable {
    let bodyParts: BodyParts
    
    enum CodingKeys: String, CodingKey {
        case bodyParts = "bodyParts"
    }
}

