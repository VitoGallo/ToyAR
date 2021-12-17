//
//  ModelDeletionManager.swift
//  dinosAR
//
//  Created by Vito Gallo on 11/12/21.
//

import SwiftUI
import RealityKit
import UIKit

class ModelDeletionManager: ObservableObject {
    
    @EnvironmentObject var arView: CustomARView
    @Published var isTapped: Bool = false
    
    @Published var currentImage: String = ""
    @Published var entitySelectedForDeletion: ModelEntity? = nil{
        willSet(newValue){
            
            
            if self.entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue{
                // Selected new entitySelectedForDeletion, no prior selection
                isTapped = true
                // Highight newSelectedModelEntity
                //                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                
                //                newlySelectedModelEntity.modelDebugOptions = component
                //                arView.installGestures(.all, for: entitySelectedForDeletion!)
                
            } else if let previouslySelectedModelEntity = self.entitySelectedForDeletion, let newlySelectedModelEntity = newValue{
                // Selected new entitySelectedForDeletion, had a prior selection
                
                // Un-highight newSelectedModelEntity
                //                previouslySelectedModelEntity.modelDebugOptions = nil
                
                //                arView.installGestures(.all, for: newlySelectedModelEntity)
                
                // Highight newSelectedModelEntity
                //                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                //                newlySelectedModelEntity.modelDebugOptions = component
            } else if newValue == nil{
                
                // Claring entitySelectedForDeletion
                //                self.entitySelectedForDeletion?.modelDebugOptions = nil
                
            }
            
        }
    }
    
    func updateCurrentImage(with name: String) {
        self.currentImage = name
    }
    
}
