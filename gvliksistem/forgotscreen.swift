//
//  forgotscreen.swift
//  gvliksistem
//
//  Created by Sebahattin Ünlü on 27.07.2023.
//

import SwiftUI
struct CustomTextFieldStyle4: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10) // içerik etrafında bir boşluk oluşturur.
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black, lineWidth: 1) // Kenar çizgisini ekler.
                    .background(Color.white) // İçi beyaz bir arka plan ekler.
            )
    }
}
struct forgotscreen: View {
    @State private var email: String = ""
    
    var body: some View {
        ZStack {
            // Arkaplan
            Image("forgotback")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // E-posta giriş alanı
                HStack {
                    Image(systemName: "envelope")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                    TextField("E-posta", text: $email)
                    
                        .textFieldStyle(CustomTextFieldStyle4())
                        
                        .frame(width: 350,height: 50)
                }
                .padding(.horizontal)
                
                // Gönder butonu
                Button(action: {
                    // Gönder butonuna basıldığında yapılacak işlemler
                }) {
                    Text("Gönder")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 400, height: 50)
                        .background(Color.green)
                        .cornerRadius(25)
                }
            }
            .padding(.top,150)
        
        }
    }
}

struct forgotscreen_Previews: PreviewProvider {
    static var previews: some View {
        forgotscreen()
    }
}
