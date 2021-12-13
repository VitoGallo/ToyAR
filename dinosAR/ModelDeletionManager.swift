//
//  ModelDeletionManager.swift
//  dinosAR
//
//  Created by Vito Gallo on 11/12/21.
//

import SwiftUI
import RealityKit

class ModelDeletionManager: ObservableObject {
    @Published var entitySelectedForDeletion: ModelEntity? = nil{
        willSet(newValue){
            
            
            if self.entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue{
                // Selected new entitySelectedForDeletion, no prior selection
                
                // Highight newSelectedModelEntity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                
                newlySelectedModelEntity.modelDebugOptions = component
            } else if let previouslySelectedModelEntity = self.entitySelectedForDeletion, let newlySelectedModelEntity = newValue{
                // Selected new entitySelectedForDeletion, had a prior selection
                
                // Un-highight newSelectedModelEntity
                previouslySelectedModelEntity.modelDebugOptions = nil
                
                // Highight newSelectedModelEntity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if newValue == nil{
                
                // Claring entitySelectedForDeletion
                self.entitySelectedForDeletion?.modelDebugOptions = nil
            }
            
        }
    }
    
}
