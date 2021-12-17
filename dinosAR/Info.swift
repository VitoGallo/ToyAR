//
//  Info.swift
//  dinosAR
//
//  Created by Vito Gallo on 16/12/21.
//

import SwiftUI
import WebKit

struct Info: View {
    @Binding var showInfo: Bool
    
    var body: some View {
        VStack(alignment: .center){
            ZStack{
                Capsule()
                    .frame(width: 40, height: 6)
            }.frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.00001))
                .onTapGesture {
                    showInfo = false
                }
            
            
            Text("Find a flat surface").font(.title)
                .padding(.bottom, 30)
            
            Gif(name: "track")
                .frame(width: 350, height: 190)
                .cornerRadius(22)
                .padding(.bottom, 50)
            
            Text("Find a flat surface. When the yellow box \nis parallel to the selected plane, \nyou are ready to place your toy.").font(.body)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            
            Button(action: {
                showInfo = false
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 130.0)
                    .padding(.vertical, 15.0)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
            
        }.interactiveDismissDisabled(showInfo)
    }
}

//struct Info_Previews: PreviewProvider {
//    static var previews: some View {
//        Info()
//    }
//}


struct Gif: UIViewRepresentable{
    private let name: String
    
    init(name: String){
        self.name = name
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        
        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
    
}
