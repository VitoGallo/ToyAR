//
//  CustomARView.swift
//  dinosAR
//
//  Created by Vito Gallo on 11/12/21.
//

import RealityKit
import ARKit
import FocusEntity

class CustomARView: ARView {
    
    var focusEntity: FocusEntity?
    var modelDeletionManager: ModelDeletionManager
    
    required init(frame frameRect: CGRect, modelDeletionManager: ModelDeletionManager) {
        
        self.modelDeletionManager = modelDeletionManager

        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
        
        self.enableObjectDelection()
        
//        self.installGestures(.all, for: )

    }
    
    required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        
        // Start AR session
        //ARWorldTrackingConfiguration to automatically detect horizontal planes
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        session.run(config)
    }
}

extension CustomARView{
    func enableObjectDelection(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer){

        let touchLocation = recognizer.location(in: self)
//     print(touchLocation)

//        if let entity = self.entity(at: CGPoint(x: 100, y: 100)) as? ModelEntity{
        
        
        
        if let entity = arView.entity(at: touchLocation) as? ModelEntity{
    

            modelDeletionManager.entitySelectedForDeletion = entity
        }
        
        
        
//        print("ciao 1 \(arView.entity(at: touchLocation))")
//        print("ciao 2 \(self.entity(at: touchLocation))")
//        print("ciao 2 \(self.entity(at: touchLocation))")
        
//        let results = self.raycast(from: touchLocation, allowing: .estimatedPlane, alignment: .any)
//
//        if let firstResult = results.first{
//            let anchor = ARAnchor(name: "AAA", transform: firstResult.worldTransform)
//            self.session.add(anchor: anchor)
//            print("jgkjhlhlk")
//
//        }
        
//        let ent = arView.entity(at: touchLocation) as? ModelEntity
//        print(ent)
//        print(self.entity(at: location)as? ModelEntity?)
//        let collisions: [CollisionCastHit] = self.hitTest(touchLocation)
//        print("coll \(collisions)")
//        if let firstCollision = collisions.first {
//            print("1 coll \(firstCollision)")
//            let entity = firstCollision.entity
//            print("VVVVVVV")
        }

     
    }

