//
//  PainSeverity.swift
//  Visual Symptom Kit
//
//  Created by Afeez Yunus on 08/10/2024.
//

import SwiftUI
import RiveRuntime

struct PainSeverity: View {
    @State var isSelected: Bool = false
    @Binding var selectedSeverity: String
    @State var description: String = ""
    @State var action: () -> Void
    let severityTypes: [String] = ["Mild", "Moderate", "Severe", "Very severe"]
    
    var body: some View {
        
        VStack (spacing:24){
            HStack (alignment: .bottom, spacing: 8){
                ForEach(severityTypes, id: \.self) { severityType in
                    let checkmark = RiveViewModel(fileName: "checkmark", stateMachineName:"Checkmark", fit:.contain, artboardName: "Checkmark 2")
                    VStack {
                        Text(severityType)
                            .foregroundStyle(severityType == selectedSeverity ? Color("text.primary") :.secondary)
                            .fontWeight(severityType == selectedSeverity ? .medium : .regular)
                        
                            
                            HStack {Spacer()
                                     checkmark.view()
                                    .frame(width: 16, height: 16)
                              /*  if severityType == selectedSeverity {
                                    
                                      Image(systemName:"checkmark")
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        .transition(.move(edge: .bottom))
                                } */
                                
                                Spacer()
                            }.frame(height: 46)
                            .background(Color("semantic.\(severityType)").opacity( severityType == selectedSeverity ? 1 : 0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 64))
                        
                       .onAppear {
                           if severityType == selectedSeverity {
                               checkmark.triggerInput("Active")
                       }
                        }
                       .onChange(of: selectedSeverity) {oldValue, newValue in
                           if severityType == selectedSeverity {
                               checkmark.triggerInput("Active")
                           } else {
                               checkmark.triggerInput("idle")
                           }
                       }
                    }
                    
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.1)){
                            selectedSeverity = severityType
                        }
                        action()
                        
                    }
                }
            }
            
            VStack {
                HStack {
                    Text("Description")
                        .fontWeight(.medium)
                        
                    Spacer()
                    Text("Optional")
                        .foregroundStyle(.secondary)
                }
                TextField("Describe in detail...", text: $description,axis: .vertical)
                    .tint(Color("text.secondary"))
                    .padding()
                    .background(Color("bg.tertiary"))
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .lineLimit(4)
            }
        }
    }
}

#Preview {
    PainSeverity(selectedSeverity: Binding.constant("Moderate"), action: {
        
    })
}
