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
    @State var title:String = "How do you feel today?"
    @State var zoom:String  = "Front1"
    @State var isStarting = false
    @State var subTitle = "I feel pain in my"
    @State var selectedPills:[String] = []
    @State var isPillSelected:Bool = false
    @State var selectedSeverity:String = "Mild"
    
    
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
                        if !isStarting {
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
                .allowsHitTesting(stage == .selectPart)
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
                                bodyView.triggerInput("front?")
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
                                bodyView.triggerInput("back?")
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
                    .onChange(of: bodyView.musclePart, { oldValue, newValue in
                        withAnimation{
                            selectedBodyPart = newValue
                        }
                    })
                    .onChange(of: bodyView.zoomState) { oldValue, newValue in
                        if bodyView.zoomState != "idle" {
                            withAnimation(.timingCurve(0.42, 0, 0.09, 0.99, duration: 0.5)) {
                                isStarting = true
                            }
                        }
                        
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
            //------------------------------------------Screen 2: select body part modal
            
            if isStarting {
                VStack {Spacer()
                        VStack{
                            VStack {
                                VStack(spacing:8){
                                    Text(subTitle)
                                        .foregroundStyle(Color("text.secondary"))
                                    if stage == .selectPart {
                                        Text(selectedBodyPart)
                                            .contentTransition(.numericText())
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .foregroundStyle(Color("text.primary"))
                                        
                                    }
                                }.padding()
                            }
                            if stage == .selectPart {
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
                            }
                            
              //------------------------------------------Screen 3: select pain type
                            else if stage == .painType {
                                PainTypeView(selectedPills: $selectedPills)
                                    .padding(8)
                            }
             
       //------------------------------------------Screen 4: select pain severity
                            else if stage == .severity {
                                
                                PainSeverity(selectedSeverity:$selectedSeverity) {
                                    bodyView.triggerInput("\(selectedBodyPart)-\(selectedSeverity)")
                                }.onAppear{
                                    bodyView.triggerInput("\(selectedBodyPart)-\(selectedSeverity)")
                                }
                                    .padding(8)
                            }
        //-----------------------------------------------------------------------------Buttons
                            HStack{
                                Button {
                                    if stage == .selectPart {
                                        withAnimation(.timingCurve(0.84, -0.01, 1, 0.68, duration: 0.5)){
                                            isStarting = false
                                        }
                                        bodyView.setInput("zoomState", value: Double (0))
                                        selectedPills.removeAll()
                                    }
                                    
                                    else if stage == .painType {
                                        withAnimation(.spring(duration: 0.3)){
                                            stage = .selectPart
                                        }
                                        bodyView.setInput("active?", value: true)
                                    } else if stage == .severity {
                                        withAnimation(.spring(duration: 0.3)){
                                            stage = .painType
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.down")
                                        .rotationEffect(.degrees(stage == .selectPart ? 0 : 90 ))
                                        .padding()
                                        .foregroundStyle(Color("text.primary"))
                                        .frame(width:115)
                                    
                                }
                                
                                Button {
                                    if stage == .selectPart {
                                        withAnimation(.spring(duration: 0.3)) {
                                            stage = .painType
                                        }
                                        bodyView.setInput("active?", value: false)
                                    } else if stage == .painType {
                                        withAnimation(.spring(duration: 0.3)) {
                                            stage = .severity
                                        }
                                    }
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
                              .disabled(
                                    stage == .painType && selectedPills.isEmpty
                                    )
                            }
                            .padding(.bottom, 4)
                            
                        }
                        .padding(8)
                        .frame(height: stage == .selectPart ? 450 : nil)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.white)
                                .shadow(color:.black.opacity(0.1), radius: 16)
                        )
                }.zIndex(2)
                    .transition(.move(edge: .bottom))
            }
            
        }
        .preferredColorScheme(.light)
        .padding()
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            loadBodyPartsData()
        }
        .onChange(of: stage) { oldValue, newValue in
            if stage == .start {
                title = "How do you feel today?"
                subTitle = ""
            } else if stage == .selectPart {
                title = "Where do you feel pain?"
                subTitle = "I feel pain in my"
            } else if stage == .painType {
                title = "What type of pain do you feel?"
                subTitle = "Type of Pain"
            } else if stage == .severity {
                title = "How much does it hurt?"
                subTitle = "Level of Pain"
            }
            
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
                    .foregroundStyle(Color(isSelected ? "text.primary" :"text.secondary"))
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

extension Color {
    static let darkGreen = Color(red: 0.0, green: 0.5, blue: 0.0) // Darker shade of green
}


