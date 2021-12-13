//
//  PlacementView.swift
//  dinosAR
//
//  Created by Vito Gallo on 11/12/21.
//

import SwiftUI

struct PlacementView: View{
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View{
        HStack{
            Button(action: {
                print("Cancel")
                self.resetPlacementParameters()
            }){
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            Button(action: {
                print("Confirm")
                self.modelConfirmedForPlacement = self.selectedModel
                self.resetPlacementParameters()
            }){
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }.padding(.bottom, 15)
        
    }
    func resetPlacementParameters(){
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}


