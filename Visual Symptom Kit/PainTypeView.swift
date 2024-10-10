//
//  PainTypeView.swift
//  Visual Symptom Kit
//
//  Created by Afeez Yunus on 08/10/2024.
//

import SwiftUI

struct PainTypeView: View {
    
    @State var painTypes = PainType()
    @Binding var selectedPills:[String]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 8) {
            ForEach(painTypes.painType, id:\.self) { pain in
                HStack{
                    Spacer()
                    Text(pain)
                        .foregroundStyle(Color(selectedPills.contains(pain) ? .black.opacity(0.8) : .secondary))
                        .fontWeight(selectedPills.contains(pain) ? .medium : .regular)
                    Spacer()
                }.frame(height:45)
                    .background(
                        RoundedRectangle(cornerRadius: 64)
                            .fill(selectedPills.contains(pain) ? Color.gray.opacity(0.2) : Color.secondary.opacity(0.04))
                            .stroke(selectedPills.contains(pain) ? Color.gray : Color.secondary.opacity(0), lineWidth: (2))
                    )
                    .scaleEffect(selectedPills.contains(pain) ? 0.9 : 1)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.1)){
                            if selectedPills.contains(pain) {
                                selectedPills.removeAll(where: { $0 == pain })
                            } else {
                                selectedPills.append(pain)
                            }
                        }
                    }
            }
        }
        
    }
}
