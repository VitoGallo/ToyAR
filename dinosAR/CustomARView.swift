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
        
        if let entity = arView.entity(at: touchLocation) as? ModelEntity{
            
            
            modelDeletionManager.entitySelectedForDeletion = entity
        }
        
        
    }
    
    
}

