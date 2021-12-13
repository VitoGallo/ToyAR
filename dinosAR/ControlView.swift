//
//  ControlView.swift
//  dinosAR
//
//  Created by Vito Gallo on 11/12/21.
//

import SwiftUI
import AudioToolbox
import RealityKit

struct ControlView: View {
    @Binding var showSheet: Bool
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelDeletionManager: ModelDeletionManager
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
//    @EnvironmentObject var sceneManager: SceneManager
    var body: some View{
        HStack{
            ControlButton(systemIconName: "xmark.circle"){
                guard let anchor = modelDeletionManager.entitySelectedForDeletion?.anchor else {return}

                let anchoringIdentifier = anchor.anchorIdentifier
//                if let index = sceneManager.anchorEntities.firstIndex(where: {$0.anchorIdentifier == anchoringIdentifier}){
//                    self.sceneManager.anchorEntities.remove(at: index)
//                }
            }
            
            Spacer()
            
            ControlButton(systemIconName: "arrow.counterclockwise.circle"){
                    
                
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


