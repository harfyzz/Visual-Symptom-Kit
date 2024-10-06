//
//  ContentView.swift
//  Visual Symptom Kit
//
//  Created by Afeez Yunus on 06/10/2024.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    @State private var isBack: Bool = false
    @StateObject private var bodyView = BodyViewModel()
    
    var body: some View {
        VStack {
            Text("How do you feel?")
                .font(.headline)
                .foregroundStyle(Color("text.primary"))
            Spacer()
            ZStack {
                VStack {
                    HStack {
                        VStack{
                            Image(systemName: "waveform.path.ecg")
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(Color.green)
                                .clipShape(Circle())
                            
                            Text("120/80")
                                .font(.largeTitle)
                                .fontWeight(.medium)
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "heart.fill")
                                .padding(4)
                                .foregroundStyle(.white)
                                .background(Color.red)
                                .clipShape(Circle())
                            
                            HStack (alignment: .bottom) {
                                Text("82")
                                    .font(.largeTitle)
                                    .fontWeight(.medium)
                                Text("BPM")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .frame(height: 30)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 32)
                bodyView.view()
            }
            VStack (spacing:16){
                
                    ZStack {
                        
                        HStack{
                            if isBack {
                                Spacer()
                                    .frame(width: 140, height: 50)
                            }
                            RoundedRectangle(cornerRadius: 64)
                                .fill(.white)
                                .frame(width: 140, height: 50)
                                .shadow(
                                    color: .black.opacity(0.02),
                                    radius: 10,
                                    x: 0,
                                    y: 1
                                )
                            
                            if !isBack {
                                Spacer()
                                    .frame(width: 140, height: 50)
                            }
                        }
                        .padding(4)
                        HStack{
                            Button {
                                withAnimation{
                                    isBack = false
                                }
                            } label: {
                                Text("Front")
                                    .foregroundStyle(
                                        Color(
                                            isBack ? "text.secondary" :"text.primary"
                                        )
                                    )
                                    .fontWeight(isBack ? .regular : .medium)
                                    .frame(width: 140, height: 50)
                                    
                                
                            }
                            
                            Button {
                                withAnimation{
                                    isBack = true
                                }
                            } label: {
                                Text("Back")
                                    .foregroundStyle(
                                        Color(isBack ? "text.primary" :"text.secondary")
                                    )
                                    .fontWeight(isBack ? .medium : .regular)
                                    .frame(width: 140, height: 50)
                                    
                            }
                        }
                }
                    .onChange(of: isBack) { oldValue, newValue in
                        bodyView.setInput("back?", value: isBack)
                    }
                .background(
                    RoundedRectangle(cornerRadius: 64)
                        .fill(Color("bg.secondary"))
                )
                VStack{
                    Text("Where do you feel pain or discomfort?")
                        .font(.headline)
                        .foregroundStyle(Color("text.primary"))
                    
                    Text(
                        "Tap any body part in the image above that represents where you feel pain or discomfort."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
