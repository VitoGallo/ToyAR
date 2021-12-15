//
//  SheetView.swift
//  dinosAR
//
//  Created by Vito Gallo on 11/12/21.
//

import SwiftUI
import CoreML

struct SheetView: View {
    var arView: CustomARView
    @Binding var showSheet: Bool
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    
    var models: [Model] = {
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var avaibleModels: [Model] = []
        for filename in files where filename.hasSuffix("usdz"){
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName) {
                model in
//                arView.installGestures([.translation, .rotation, .scale], for: model)
            }
            
            avaibleModels.append(model)
        }
        return avaibleModels
    }()
    
    var body: some View {
        NavigationView{
            
            ScrollView(showsIndicators: false){
                
                ModelPicker(showSheet: $showSheet, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, models: self.models)
                
            }.background(Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255))
                .navigationBarTitle(Text("Select the object:"), displayMode: .large)
        }
        
    }
    
    
}

struct ModelPicker: View{
    
    @Binding var showSheet: Bool
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            
            HStack(spacing: 15){
                ForEach(0..<self.models.count) { index in
                    Button(action: {
                        self.selectedModel = self.models[index]
                        selectedModel?.asyncLoadModelEntity()
                        
                        self.isPlacementEnabled = true
                        self.showSheet = false
                    })
                    {
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 150)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                }
            }.padding(.horizontal, 22)
            
        }
    }
}




