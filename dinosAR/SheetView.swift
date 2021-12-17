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
    
    @State private var curHeight: CGFloat = 310
    var minHeight: CGFloat = 300
    var maxHeight: CGFloat = 350
    @State private var isDragging = false
    let startOpacity = 0.4
    let endOpacity = 0.8
    
    var dragPercentage: Double{
        let res = Double((curHeight - minHeight) / (maxHeight - minHeight))
        return max(0, min(1, res))
    }
    
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
        ZStack(alignment: .bottom){
            if showSheet{
                Color.black
                    .opacity(startOpacity + (endOpacity - startOpacity) * dragPercentage)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showSheet = false
                    }
                mainView.transition(.move(edge: .bottom))
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .animation(.easeOut(duration: 2), value: 1.0)
    }
    
    var mainView: some View{
        VStack{
            ZStack{
                Capsule()
                    .frame(width: 40, height: 6)
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.00001))
                .gesture(dragGesture)
            
            VStack{
                HStack{
                    Text("Select the object:").font(.title2)
                    Spacer()
                }.padding(.horizontal, 22)
                    .padding(.bottom, 10)
                
                ModelPicker(showSheet: $showSheet, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, models: self.models)
                
            }.frame(maxHeight: .infinity)
                .padding(.bottom, 40)
            
        }.frame(height: curHeight)
            .frame(maxWidth: .infinity)
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                    Rectangle()
                        .frame(height: curHeight/2)
                }.foregroundColor(Color.white)
            ).animation(isDragging ? nil : .easeInOut(duration: 0.45), value: 1.0)
    }
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture{
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged{ val in
                if !isDragging{
                    isDragging = true
                }
                
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > maxHeight || curHeight < minHeight{
                    curHeight -= dragAmount / 6
                } else{
                    curHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded{ val in
                prevDragTranslation = .zero
                isDragging = false
                if curHeight > maxHeight{
                    curHeight = maxHeight
                }
                else if curHeight < minHeight{
                    curHeight = minHeight
                }
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
                        ZStack{
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                                .frame(width: 155, height: 155)
                                .cornerRadius(12)
                            
                            Image(uiImage: self.models[index].image)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .aspectRatio(1/1, contentMode: .fit)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                }
                
            }.padding(.horizontal, 22)
            
        }
    }
}




