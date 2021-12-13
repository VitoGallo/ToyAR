//
//  ContentView.swift
//  dinosAR
//
//  Created by Vito Gallo on 08/12/21.
//

//import ARKit
import SwiftUI
import RealityKit

//@EnvironmentObject var modelDeletionManager: ModelDeletionManager
var modelDeletionManager = ModelDeletionManager()
let arView = CustomARView(frame: .zero, modelDeletionManager: modelDeletionManager)

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
                ControlView(showSheet: $showSheet, isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, modelDeletionManager: $modelDeletionManager)
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






#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
