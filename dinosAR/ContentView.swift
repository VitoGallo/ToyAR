//
//  ContentView.swift
//  dinosAR
//
//  Created by Vito Gallo on 08/12/21.
//

//import ARKit
import SwiftUI
import RealityKit
import AudioToolbox
import FocusEntity

//@EnvironmentObject var modelDeletionManager: ModelDeletionManager
var modelDeletionManager = ModelDeletionManager()
let arView = CustomARView(frame: .zero, modelDeletionManager: modelDeletionManager)
var sceneManager: SceneManager = SceneManager()

struct ContentView : View {
    
    @State private var showSheet: Bool = false
    @State var isPlacementEnabled: Bool = false
    @State var selectedModel: Model?
    @State var modelConfirmedForPlacement: Model?
//    @State var modelDeletionManager: ModelDeletionManager?
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            ARViewContainer(selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement).edgesIgnoringSafeArea(.all)
 
            if self.isPlacementEnabled{
                PlacementView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
//            } else if modelDeletionManager.entitySelectedForDeletion != nil{
//                DelectionView()
            } else{
                ControlView(showSheet: $showSheet, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel)
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
    

//    @StateObject var sceneManager: SceneManager
//    @EnvironmentObject var sceneManager: SceneManager
    
    func makeUIView(context: Context) -> CustomARView {

        // Add coaching overlay
        //ARCoachingOverlayView which guides the user until the first plane is found
        //        let coachingOverlay = ARCoachingOverlayView()
        //        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        coachingOverlay.session = session
        //        coachingOverlay.goal = .horizontalPlane
        //        arView.addSubview(coachingOverlay)
        
        // Set debug options
        //        #if DEBUG
        //        arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        //        #endif
        
        return arView
        
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {

        arView.focusEntity?.isEnabled = self.selectedModel != nil
        
        
        if let model = self.modelConfirmedForPlacement {
            
            if let modelEntity = model.modelEntity{
              
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                uiView.scene.addAnchor(anchorEntity)
                sceneManager.anchorEntities.append(anchorEntity)
//                modelEntity.generateCollisionShapes(recursive: true)
//                arView.installGestures([.translation, .rotation, .scale], for: modelEntity)
            }
//            print(uiView.scene.anchors.)
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
            
    
        }
        // Occlusion(?)
//        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        
//        var modelEntity = model.modelEntity
        
//        func abc(on object: ModelEntity){
//        object.generateCollisionShapes(recursive: true)
//        arView.installGestures(.scale, for: object)
//        }
    }
    
//    func abc(){
//        guard let anchor = modelDeletionManager.entitySelectedForDeletion?.anchor else {return}
//    }
  


    

}

class SceneManager: ObservableObject{
//    @Published var isPersistanceAvailable: Bool = false
    @Published var anchorEntities: [AnchorEntity] = []
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
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
//    @Binding var modelDeletionManager: ModelDeletionManager
    @State var shouldFlash = false

    var body: some View {
        ZStack{
        VStack{
            ControlTopBar()

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
//    @Binding var sceneManager: SceneManager
    var body: some View{
        HStack{
            ControlButton(systemIconName: "xmark.circle"){
                guard let anchor = modelDeletionManager.entitySelectedForDeletion?.anchor else {return}
//
                let anchoringIdentifier = anchor.anchorIdentifier
                if let index = sceneManager.anchorEntities.firstIndex(where: {$0.anchorIdentifier == anchoringIdentifier}){
                    sceneManager.anchorEntities.remove(at: index)
//                    print(sceneManager.anchorEntities.count)
                }
                anchor.removeFromParent()
                modelDeletionManager.entitySelectedForDeletion = nil
            }
            
            Spacer()
            
            ControlButton(systemIconName: "arrow.counterclockwise.circle"){
                for anchorEntity in sceneManager.anchorEntities{
                    anchorEntity.removeFromParent()
                }
//                arView.scene.anchors.removeAll()

                
                
            }
        }.frame(maxWidth: 500)
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
    }
}


struct ControlBottomBar: View{
    @Binding var showSheet: Bool
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var shouldFlash: Bool

    var body: some View{

        HStack{
                        
            ControlButton(systemIconName: "plus.circle"){
                self.showSheet.toggle()
                
            }.sheet(isPresented: $showSheet, content: {
                SheetView(showSheet: $showSheet, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel)
            })
            Spacer()
            
            Spacer()
            
            ControlButton(systemIconName: "camera.circle"){

                takeSnapshot()
                shouldFlash = true
            }
            
            
        }.frame(maxWidth: 500)
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
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

func takeSnapshot(){
    arView.snapshot(saveToHDR: false){(image) in
        let compressedImage = UIImage(data:(image?.pngData())!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
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


