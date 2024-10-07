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
    @State private var stage:Stages = .start
    @State var isSelected = false
    @State private var selectedBodyPart = ""
    @State var title:String = "How do you feel?"
    @State var zoom:String  = "Front1"
    
    
    var body: some View {
        ZStack {
            VStack {
                //------------------------------------------------------------header/title
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color("text.primary"))
                Spacer()
                ZStack {
                    //----------------------------------------------------stats
                    VStack {
                        if stage == .start {
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
                        }
                        Spacer()
                    }
                    .padding(.top, 32)
                    //---------------------------------------------- Rive view
                    bodyView.view()
                }
                .onChange(of: bodyView.zoomState) { oldValue, newValue in
                    if bodyView.zoomState != "idle" {
                        withAnimation(.timingCurve(0.42, 0, 0.09, 0.99, duration: 0.5)) {
                            stage = .selectPart
                        }
                    }
                    
                }
                //---------------------------------------------------- front/back tab
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
                    .onChange(of: bodyView.musclePart, { oldValue, newValue in
                        withAnimation{
                            selectedBodyPart = newValue
                        }
                        
                    })
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
            //------------------------------------------select body part modal
            if stage == .selectPart {
                VStack {Spacer()
                    VStack{
                        HStack {
                            Spacer()
                            VStack(spacing:8){
                                Text("I feel pain in my ...")
                                    .foregroundStyle(Color("text.secondary"))
                                
                                Text(selectedBodyPart)
                                    .contentTransition(.numericText())
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("text.primary"))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color("bg.tertiary"))
                        .clipShape(RoundedRectangle(cornerRadius: 64))
                        //---------------------------------------------------For Each section
                        ScrollView {
                            if let bodyParts = bodyPartsData?.bodyParts,
                               let currentBodyParts = getBodyPartsArray(for: bodyParts, zoomState: bodyView.zoomState) {
                                ForEach(currentBodyParts, id: \.self) { part in
                                    BodyItem(item: part, isSelected: selectedBodyPart == part)
                                        .onTapGesture {
                                            isSelected = true
                                            withAnimation{
                                                selectedBodyPart = part
                                                bodyView.triggerInput(part)
                                            }
                                            if part == "Chest" {
                                                bodyView.setInput("zoomState", value: Double(1))
                                            }
                                            else if part == "Upper back" {
                                                bodyView.setInput("zoomState", value: Double(11))
                                            }
                                        }
                                }
                            } else {
                                Text("No body parts available")
                            }
                        }.scrollIndicators(.hidden)
                        HStack{
                            Button {
                                withAnimation(.timingCurve(0.84, -0.01, 1, 0.68, duration: 0.5)){
                                    stage = .start
                                }
                                bodyView.setInput("zoomState", value: Double (0))
                                
                            } label: {
                                Image(systemName: "arrow.down")
                                    .padding()
                                    .foregroundColor(Color("text.primary"))
                                    .frame(width:115)
                                
                            }
                            Button {
                                stage = .painType
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Continue")
                                        .padding()
                                    Spacer()
                                }
                                .background(Color("bg.dark"))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 64))
                                
                            }
                            
                            
                        }
                        .padding(.bottom, 8)
                    }
                    .padding(8)
                    .frame(height:450)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .shadow(color:.black.opacity(0.2), radius: 16)
                }
                .zIndex(2)
                .transition(.move(edge: .bottom))
                
                
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
    func getBodyPartsArray(for bodyParts: BodyParts, zoomState: String) -> [String]? {
        let mirror = Mirror(reflecting: bodyParts)
        
        // Dynamically access the property by name
        if let bodyPartArray = mirror.children.first(where: { $0.label == zoomState })?.value as? [String] {
            return bodyPartArray
        }
        
        return nil
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
