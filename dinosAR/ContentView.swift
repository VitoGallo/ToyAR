//
//  ContentView.swift
//  dinosAR
//
//  Created by Vito Gallo on 08/12/21.
//

import SwiftUI
import RealityKit
import AudioToolbox
import FocusEntity

var sceneManager: SceneManager = SceneManager()

struct ContentView : View {
    
    @State private var showSheet: Bool = false
    @State private var showInfo: Bool = false
    
    @State var isPlacementEnabled: Bool = false
    @State var selectedModel: Model?
    @State var modelConfirmedForPlacement: Model?

    @EnvironmentObject var model: ModelDeletionManager
    @EnvironmentObject var arView: CustomARView

    
    var body: some View {
        ZStack(alignment: .bottom){
            
            ARViewContainer(selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement).edgesIgnoringSafeArea(.all)
 
            if self.isPlacementEnabled{
                PlacementView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
//            } else if modelDeletionManager.entitySelectedForDeletion != nil{
//                DelectionView()
            } else if self.showSheet {
                SheetView(arView: arView, showSheet: $showSheet, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel)
            } else{
                ControlView(showSheet: $showSheet, showInfo: $showInfo, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel)
            }
        }
    }

}

//            HStack{
//                Spacer()
//                Button(action: {
//                    takeSnapshot()
//                }) {
//                    ZStack{
//                        Circle()
//                            .strokeBorder(Color.white, lineWidth: 5)
//                            .frame(width: 100, height: 100)
//
//                        Image(systemName: "circle.fill")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 80, height: 80)
//                            .clipped()
//                            .foregroundColor(.white)
//                    }.padding(.bottom, 15)
//
//                }
//                Spacer()
//
//            }.frame(height: 100)






struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    @EnvironmentObject var arView: CustomARView
    
    func makeUIView(context: Context) -> CustomARView {

        // Add coaching overlay
//        ARCoachingOverlayView which guides the user until the first plane is found
//                let coachingOverlay = ARCoachingOverlayView()
//                coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                coachingOverlay.session = session
//                coachingOverlay.goal = .horizontalPlane
//                arView.addSubview(coachingOverlay)
        
        // Set debug options
        //        #if DEBUG
        //        arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        //        #endif
        
        return arView
        
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {

        arView.focusEntity?.isEnabled = self.selectedModel != nil
        
        if let model = self.modelConfirmedForPlacement {
//            arView.installGestures(.all, for: model.modelEntity)

            if let modelEntity = model.modelEntity{
                modelEntity.name = model.modelName
//                print("VVVVV\(modelEntity.name)")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                uiView.scene.addAnchor(anchorEntity)
                sceneManager.anchorEntities.append(anchorEntity)
                
//                modelEntity.playAnimation(modelEntity.availableAnimations.first!)
//                sceneManager.anchorEntitiesName.append(model.modelName)

            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
            
            
    
        }
        // Occlusion(?)
//        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        
    }



}

class SceneManager: ObservableObject{
    @Published var anchorEntities: [AnchorEntity] = []
//    @Published var anchorEntitiesName: [String] = []
}





//
//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif

struct ControlView: View {
    @Binding var showSheet: Bool
    @Binding var showInfo: Bool

    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @State var shouldFlash = false

    

    var body: some View {
        ZStack{
        VStack{
            ControlTopBar(showInfo: $showInfo)

            Spacer()
            
            ControlBottomBar(showSheet: $showSheet, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, shouldFlash: $shouldFlash)
        }
            FlashView(shouldFlash: $shouldFlash)
                            .ignoresSafeArea()
                            .allowsHitTesting(false)
        }
    }
}

struct ControlTopBar: View{
    @EnvironmentObject var model: ModelDeletionManager
    @Binding var showInfo: Bool

    var body: some View{
        HStack{
            ControlButton(systemIconName: "questionmark.circle"){
                showInfo = true
            }.sheet(isPresented: $showInfo, content: {
                Info(showInfo: $showInfo)
                            })
            
//            ControlButton(systemIconName: "xmark.circle"){
//                guard let anchor = model.entitySelectedForDeletion?.anchor else {return}
//
//                let anchoringIdentifier = anchor.anchorIdentifier
//                if let index = sceneManager.anchorEntities.firstIndex(where: {$0.anchorIdentifier == anchoringIdentifier}){
//
//                    sceneManager.anchorEntities.remove(at: index)
////                    sceneManager.anchorEntitiesName.remove(at: index)
////                    print(sceneManager.anchorEntitiesName)
//                }
//                anchor.removeFromParent()
//                model.currentImage = ""
//                model.entitySelectedForDeletion = nil
//            }
//            Spacer()
//
//            Image(model.currentImage)
//                .resizable()
//                .frame(height: 150)
//                .aspectRatio(1/1, contentMode: .fit)
//                .background(Color.white)
//                .cornerRadius(12)
//
//
//
            Spacer()
         
            ControlButton(systemIconName: "arrow.counterclockwise.circle"){
                model.isTapped = false
                for anchorEntity in sceneManager.anchorEntities{
                    anchorEntity.removeFromParent()
                    model.currentImage = ""

                }
//                sceneManager.anchorEntitiesName = []
//                print(sceneManager.anchorEntitiesName)
//                arView.scene.anchors.removeAll()

                
                
            }
        }.frame(maxWidth: 500)
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
    }
}


struct ControlBottomBar: View{
    @EnvironmentObject var arView: CustomARView
    @EnvironmentObject var model: ModelDeletionManager
    @Binding var showSheet: Bool
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var shouldFlash: Bool

    var body: some View{

        HStack(alignment: .bottom){
            
            VStack{
                if model.isTapped {
                ControlButton(systemIconName: "trash.circle"){
                    model.isTapped = false

                    guard let anchor = model.entitySelectedForDeletion?.anchor else {return}
                 
                                 let anchoringIdentifier = anchor.anchorIdentifier
                                 if let index = sceneManager.anchorEntities.firstIndex(where: {$0.anchorIdentifier == anchoringIdentifier}){
                 
                                     sceneManager.anchorEntities.remove(at: index)
                 //                    sceneManager.anchorEntitiesName.remove(at: index)
                 //                    print(sceneManager.anchorEntitiesName)
                                 }
                                 anchor.removeFromParent()
                                 model.currentImage = ""
                                 model.entitySelectedForDeletion = nil
                }.padding(.bottom)
                }
            ControlButton(systemIconName: "plus.circle"){
                self.showSheet = true
            }
            }
            Spacer()
            if model.isTapped {
            ZStack{
                Circle()
                
                    .fill(Color.clear)
                    .frame(height: 120)
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    

                
            Image(model.currentImage)
//

                     .resizable()
                     .scaledToFit()
                     .frame(height: 105)
                     .background(Color.clear)
                     .cornerRadius(12)
                     .clipShape(Circle())
                     .shadow(radius: 10)
//                     .overlay(Circle().stroke(Color.red, lineWidth: 5))
            }
            }
            Spacer()
                
            ControlButton(systemIconName: "camera.circle"){

                takeSnapshot()
                shouldFlash = true
            
            }
            
            
        }.frame(maxWidth: 500)
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
    }
    
    
    func takeSnapshot(){
        arView.snapshot(saveToHDR: false){(image) in
            let compressedImage = UIImage(data:(image?.pngData())!)
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        }
    }


}


struct ControlButton: View{
    let systemIconName: String
    let action: () -> Void
    
    var body: some View{
        Button(action: {
            self.action()
        }) {
            Image(systemName: self.systemIconName)
                .font(.system(size: 50))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }.frame(width: 50, height: 50)
    }
    
}

struct FlashView: UIViewRepresentable {
    @Binding var shouldFlash: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.0
        if shouldFlash {
            makeViewFlash(view)
        }
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        if shouldFlash {
            makeViewFlash(view)
        }
    }

    private func makeViewFlash(_ view: UIView) {
        PlaySound.play()
        
        view.alpha = 1.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            view.alpha = 0.0
        }){ (finished) in
            shouldFlash = false
        }
     
    }
}

class PlaySound {

static private var mySound:SystemSoundID = {
    var aSound:SystemSoundID = 1000
    
    if let soundURL = Bundle.main.url(forResource: "shutter", withExtension: ".mp3") {
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &aSound)
//      AudioServicesPlayAlertSound(aSound)

    }
    return aSound
}()

static func play() { AudioServicesPlaySystemSound(mySound) }
}


