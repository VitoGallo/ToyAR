//
//  Model.swift
//  dinosAR
//
//  Created by Vito Gallo on 08/12/21.
//

import UIKit
import RealityKit
import Combine

class Model{
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable?
    
    init (modelName: String){
        self.modelName = modelName
        
        self.image = UIImage(named: modelName)!
        
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
//            modelEntity.generateCollisionShapes(recursive: true)
//            arView.installGestures([.translation, .rotation, .scale], for: modelEntity)

        })
    }
    
    func installGestures(on object: ModelEntity){
        object.generateCollisionShapes(recursive: false)
        arView.installGestures([.translation, .rotation, .scale], for: object)

    }
    
}
