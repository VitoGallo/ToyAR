//
//  Model.swift
//  dinosAR
//
//  Created by Vito Gallo on 08/12/21.
//

import UIKit
import RealityKit
import Combine
import SwiftUI

class Model{
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    var installGestureOnArkit: (ModelEntity) -> Void
    
    @EnvironmentObject var arView: CustomARView
    
//    var installGestures: (_ gestures: ARView.EntityGestures, _ entity: HasCollision) -> [EntityGestureRecognizer]
    
    private var cancellable: AnyCancellable?
    
    init (modelName: String, installGestureOnArkit: @escaping (ModelEntity) -> Void){
        self.modelName = modelName
        
        self.image = UIImage(named: modelName)!
        self.installGestureOnArkit = installGestureOnArkit
    }
    
    func asyncLoadModelEntity(){
        
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename).sink(receiveCompletion: {loadCompletion in
            switch loadCompletion{
            case .failure: print("Unable to load modelEntity for model \(self.modelName)")
            case .finished:
                break
            }
        }, receiveValue: {modelEntity in
            //Get our modelEntity
            self.modelEntity = modelEntity
            self.installGestures(on: modelEntity)
//            arView.installGestures(.all, for: self)

            
        })
    }
    
    func installGestures(on object: ModelEntity){
        object.generateCollisionShapes(recursive: false)
//        arView.installGestures(.all, for: object)

        
        installGestureOnArkit(object)
    }
    
}


