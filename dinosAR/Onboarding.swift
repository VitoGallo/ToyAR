//
//  Onboarding.swift
//  dinosAR
//
//  Created by Vito Gallo on 16/12/21.
//

import SwiftUI

struct Onboarding: View {
    @State var isShowed: Bool = false
    @State var aaa: Bool = false
    
    var body: some View {
        VStack {
            VStack{
                VStack{
                    Text("Welcome in\n").font(.largeTitle)
                        .fontWeight(.bold) + Text("ToyAR")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("AccentColor"))
                }.padding(.bottom, 80.0)
                    .padding(.top, 30.0)
                
                
                HStack{
                    VStack{
                        Image(systemName: "arkit")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 35, weight: .regular))
                            .padding(.bottom, 50.0)
                        
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 35, weight: .regular))
                            .padding(.bottom, 6.0)
                        
                        Image(systemName: "photo")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 35, weight: .regular))
                        .padding(.top, 45.0)}
                    
                    
                    VStack(alignment: .leading, spacing: 10.0){
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Place the toys")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                            
                            Text("Select your favorite toy, \nlook for a flat surface and place it")
                                .fontWeight(.regular)
                                .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)}
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Delete and reset")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                            
                            Text("Delete one of your toys or reset \nthe whole room so you can restart")
                                .fontWeight(.regular)
                                .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)}
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Take photos")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                            
                            Text("Take photos of your sessions to \nshare them with whoever you want")
                                .fontWeight(.regular)
                                .foregroundColor(Color.gray)
                            .multilineTextAlignment(.leading)}
                        .padding(.bottom)

                    }
                    .padding(.leading)
                    
                }
                
                
                
            }
            Button(action: {isShowed.toggle()
                UserDefaults.standard.set(true, forKey: "LaunchBefore")
                aaa.toggle()
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 120.0)
                    .padding(.vertical, 15.0)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.top, 90.0)
        }
        .fullScreenCover(isPresented: $aaa){ContentView()}
    }
}



//struct Onboarding_Previews: PreviewProvider {
//    static var previews: some View {
//        Onboarding()
//    }
//}
