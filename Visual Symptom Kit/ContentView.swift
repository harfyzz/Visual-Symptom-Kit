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
    @State var isPopUp = false
    @State var subTitle = "I feel pain in my"
    @State var selectedPills:[String] = []
    @State var isPillSelected:Bool = false
    @State var selectedSeverity:String = "Mild"
    @State var hurtMuscles:[String] = []
    @State var painSession = PainSession()
    @State var selectedDescription:String = ""
    @State var painSessions = [PainSession]()
    
    
    var body: some View {
        ZStack {
            VStack {
                //------------------------------------------------------------header/title
                ZStack {
                    if stage == .summary {
                        HStack{
                            Image(systemName: "gobackward")
                            Spacer()
                        }
                        .onTapGesture {
                                for muscle in hurtMuscles {
                                    bodyView.setInput(muscle, value: false)
                                }
                            hurtMuscles.removeLast()
                            painSessions.removeLast()
                            print(hurtMuscles)
                            isBack = false
                            bodyView.triggerInput("front?")
                            stage = .selectPart
                            withAnimation(.timingCurve(0.42, 0, 0.09, 0.99, duration: 0.5)) {
                                isPopUp = false
                            }
                            
                            selectedPills.removeAll()
                            selectedSeverity = "Mild"
                            selectedDescription = ""
                        }
                    }
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Color("text.primary"))
                }
                Spacer()
                ZStack {
                    //----------------------------------------------------stats
                    VStack {
                        if !isPopUp {
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
                    VStack {
                        bodyView.view()
                    }.allowsHitTesting(stage == .selectPart)
                }
                
                //---------------------------------------------------- front/back tab
                if !isPopUp {
                    
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
                                    isPopUp = true
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
                //---------------------------------------------------- front/back tab
              
            }
            //------------------------------------------Screen 2: select body part modal
            
            if isPopUp {
                VStack {Spacer()
                    VStack{
                        VStack {
                            HStack {Spacer()
                                VStack(spacing:4){
                                    Text(subTitle)
                                        .foregroundStyle(Color("text.secondary"))
                                    if stage == .selectPart {
                                        Text(selectedBodyPart)
                                            .contentTransition(.numericText())
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .foregroundStyle(Color("text.primary"))
                                        
                                    }
                                }
                                Spacer() }.padding(8)
                                    .background(Color(stage == .selectPart ? "bg.secondary" :"bg.primary"))
                                    .clipShape(RoundedRectangle(cornerRadius: 64))
                            
                        }
                        if stage == .selectPart {
                            //---------------------------------------------------For Each section
                            VStack {
                                ScrollView {
                                    if let bodyParts = bodyPartsData?.bodyParts,
                                       let currentBodyParts = getBodyPartsArray(for: bodyParts, zoomState: bodyView.zoomState) {
                                        BodyPartsListView(
                                            bodyParts: currentBodyParts,
                                            selectedBodyPart: $selectedBodyPart,
                                            isSelected: $isSelected,
                                            bodyView: bodyView
                                        )
                                    } else {
                                        Text("No body parts available")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .padding()
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                        }
                        
                        //------------------------------------------Screen 3: select pain type
                        else if stage == .painType {
                            PainTypeView(selectedPills: $selectedPills)
                                .padding(8)
                        }
                        
                        //------------------------------------------Screen 4: select pain severity
                        else if stage == .severity {
                            
                            PainSeverity(selectedSeverity:$selectedSeverity, description:$selectedDescription) {
                                bodyView.triggerInput("\(selectedBodyPart)-\(selectedSeverity)")
                            }.onAppear{
                                bodyView.triggerInput("\(selectedBodyPart)-\(selectedSeverity)")
                            }
                            .padding(8)
                        }
                        //------------------------------------------Screen 5: summary
                        else if stage == .summary {
                            let symptoms = painSession.painTypes.joined(separator: ", ")
                                
                                // Converts each painSession to a string
                                let sessionDescriptions = painSessions.map { session in
                                    return "\(session.painSeverity), \(symptoms) pain in my \(session.painPart)"
                                }
                                
                                // Join all session descriptions with " and "
                                let sessionCollection = sessionDescriptions.joined(separator: ", and a ")
                                Text("I feel a \(sessionCollection.lowercased())")
                                        .padding()
                                        .multilineTextAlignment(.center)
                                        .lineLimit(4)
                                
                        }
                        
                        //-----------------------------------------------------------------------------Buttons
                        HStack{
                            Button {
                                if stage == .selectPart {
                                    withAnimation(.timingCurve(0.84, -0.01, 1, 0.68, duration: 0.5)){
                                        isPopUp = false
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
                                    bodyView.triggerInput(selectedBodyPart)
                                    withAnimation(.spring(duration: 0.3)){
                                        stage = .painType
                                    }
                                }
                                else if stage == .summary {
                                    isBack = false
                                    bodyView.triggerInput("front?")
                                    stage = .selectPart
                                    withAnimation(.timingCurve(0.42, 0, 0.09, 0.99, duration: 0.5)) {
                                        isPopUp = false
                                    }
                                    
                                        for muscle in hurtMuscles {
                                            bodyView.setInput(muscle, value: false)
                                        
                                    }
                                    selectedPills.removeAll()
                                    selectedSeverity = "Mild"
                                    selectedDescription = ""
                                    
                                }
                            } label: {
                                if stage == .summary {
                                    Text("Add area")
                                        .padding()
                                        .foregroundStyle(.white)
                                        .frame(width:115)
                                } else {
                                    Image(systemName: "arrow.down")
                                        .rotationEffect(.degrees(stage == .selectPart ? 0 : 90 ))
                                        .padding()
                                        .foregroundStyle(Color("text.primary"))
                                        .frame(width:115)
                                }
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
                                } else if stage == .severity {
                                    
                                    //---------------------------------------------------- add painSession
                                    painSession.painPart = selectedBodyPart
                                    painSession.painTypes = selectedPills
                                    painSession.painDescription = selectedDescription
                                    painSession.painSeverity = selectedSeverity
                                    painSessions.append(painSession)
                                    //---------------------------------------------------- add painSession end
                                    
                                    withAnimation(.timingCurve(0.84, -0.01, 1, 0.68, duration: 0.5)){
                                        title = "Summary"
                                        stage = .summary
                                        bodyView.triggerInput("front and back")
                                        
                                        bodyView.setInput("zoomState", value: Double(0))
                                        
                                    }
                                    hurtMuscles.append(selectedBodyPart)
                                    for muscle in hurtMuscles {
                                        bodyView.setInput(muscle, value: true)
                                    }
                                    
                                    print(hurtMuscles)
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    Text(stage == .severity ? "Finish" : "Continue")
                                        .padding()
                                    Spacer()
                                }
                                .background(stage == .summary ? .white : .black)
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
    func summaryText(_ text: String) -> some View {
        Text(text)
            .fontWeight(.medium)
            .foregroundColor(Color("text.primary"))
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


