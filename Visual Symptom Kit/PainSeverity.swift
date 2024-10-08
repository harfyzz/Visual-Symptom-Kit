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
                    VStack {
                        Text(severityType)
                            .foregroundStyle(severityType == selectedSeverity ? Color("text.primary") :.secondary)
                            .fontWeight(severityType == selectedSeverity ? .medium : .regular)
                        ZStack{
                            /* checkmark.view()
                             .onAppear {
                             checkmark.setInput("Active?", value:false)
                             }
                             */
                            
                            HStack {Spacer()
                                if severityType == selectedSeverity {
                                    Image(systemName:"checkmark")
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        .transition(.move(edge: .bottom))
                                }
                                
                                Spacer()
                            }
                            
                        }.frame(height: 46)
                            .background(Color("semantic.\(severityType)").opacity( severityType == selectedSeverity ? 1 : 0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 64))
                    }
                    
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.1)){
                            selectedSeverity = severityType
                        }
                        action()
                        
                        print (selectedSeverity)
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
                TextField("Describe in detail...", text: $description)
                    .padding()
                    .background(Color("bg.tertiary"))
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            }
        }
    }
}

#Preview {
    PainSeverity(selectedSeverity: Binding.constant("Moderate"), action: {
        
    })
}
