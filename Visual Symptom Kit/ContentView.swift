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
    @State private var bodyPartsData: BodyPartsData?
    @State private var stage:Stages = .selectPart
    @State var isSelected = false
    @State private var selectedBodyPart = ""
    @State var title:String = "How do you feel?"
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
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
                    VStack(spacing:8){
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
                .padding(.bottom, 32)
                
            }
            if stage == .selectPart {
                VStack {Spacer()
                    VStack{
                        HStack {
                            Spacer()
                            VStack(spacing:8){
                                Text("I feel pain in my ...")
                                    .foregroundStyle(Color("text.secondary"))
                                
                                Text("Lower back")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("text.primary"))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color("bg.tertiary"))
                        .clipShape(RoundedRectangle(cornerRadius: 64))
                        
                        ScrollView {
                            ForEach(bodyPartsData?.bodyParts.front1 ?? [], id: \.self) { part in
                                BodyItem(item: part, isSelected: selectedBodyPart == part)
                                    .onTapGesture {
                                        selectedBodyPart = part
                                        isSelected = true
                                    }
                            }
                        }.scrollIndicators(.hidden)
                    }
                    .padding(8)
                    .frame(height:320)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .shadow(color:.black.opacity(0.2), radius: 16)
                }
                
            }
        }
        .preferredColorScheme(.light)
        .padding()
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            loadBodyPartsData()
        }
    }
    func loadBodyPartsData() {
            if let url = Bundle.main.url(forResource: "BodyParts", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    bodyPartsData = try decoder.decode(BodyPartsData.self, from: data)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
    
}

enum Stages {
    case start
    case selectPart
    case painType
    case severity
    case summary
}
#Preview {
    ContentView()
}

struct BodyItem: View {
    var item: String
    var isSelected:Bool
    var body: some View {
        VStack{
            HStack{
                Text(item)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .frame(height:45)
            .padding(.horizontal)
            
            Divider()
                .tint(Color("bg.tertiary")).opacity(0.6)
        }
        .background()
    }
}
