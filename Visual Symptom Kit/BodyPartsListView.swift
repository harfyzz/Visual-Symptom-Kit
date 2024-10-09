//
//  BodyPartsListView.swift
//  Visual Symptom Kit
//
//  Created by Afeez Yunus on 09/10/2024.
//

import SwiftUI

struct BodyPartsListView: View {
    let bodyParts: [String]
    @Binding var selectedBodyPart: String
    @Binding var isSelected: Bool
    let bodyView: BodyViewModel

    var body: some View {
        ForEach(bodyParts, id: \.self) { part in
            BodyItem(item: part, isSelected: selectedBodyPart == part)
                .onTapGesture {
                    isSelected = true
                    withAnimation {
                        selectedBodyPart = part
                        bodyView.triggerInput(part)
                    }
                    handleZoomState(for: part)
                }
        }
    }

    private func handleZoomState(for part: String) {
        if part == "Chest" {
            bodyView.setInput("zoomState", value: Double(1))
        } else if part == "Upper back" {
            bodyView.setInput("zoomState", value: Double(11))
        }
    }
}
