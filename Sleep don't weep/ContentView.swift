//
//  ContentView.swift
//  Sleep don't weep
//
//  Created by Filip Pokłosiewicz on 25/02/2024.
//

import SwiftUI

struct HollowText: ViewModifier {
    var textColor: Color = .gray
    var borderColor: Color = .white
    var lineWidth: CGFloat = 2
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.clear) // Usuwa wypełnienie tekstu
            .overlay( // Dodaje obwódkę dookoła tekstu
                content
                    .foregroundColor(textColor) // Kolor wewnętrzny tekstu (używany do cienia)
                    .shadow(color: borderColor, radius: lineWidth / 2) // Cień tworzy efekt obwódki
            )
            .background( // Dodaje tło, które jest przezroczyste
                content
                    .foregroundColor(.clear) // Usuwa kolor tła
                    .overlay( // Dodaje obwódkę tekstu
                        RoundedRectangle(cornerRadius: lineWidth * 2) // Ustawia zaokrąglenie rogów
                            .stroke(borderColor, lineWidth: lineWidth) // Definiuje kolor i grubość linii obwódki
                            )
            )
    }
}


struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var pulsate = false
    
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            
            //  Spacer()
            
            VStack {
                
                Text(viewModel.remainingTime != nil ? "\(Int(floor(viewModel.remainingTime! / 60))):\(String(format: "%02d", Int(viewModel.remainingTime!) % 60))" : "00:00")
                    .foregroundColor(viewModel.remainingTime != nil ? .white : .clear)
                    .font(.system(size: 100, weight: .ultraLight))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .opacity(0.5)
                Spacer()
                
                Button(action: {
                    viewModel.playOrPause()
                    
                }) {
                    Image("Icon-inside")
                    
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .scaleEffect(pulsate ? 1.2 : 1) // Apply scale effect based on the pulsate state
                        .animation(pulsate ? Animation.easeInOut(duration: 2.6).repeatForever(autoreverses: true) : .default, value: pulsate) // Apply pulsating animation
                    
                }
                .onAppear {
                    if viewModel.isPlaying {
                        self.pulsate = true
                    }
                }
                .onChange(of: viewModel.isPlaying) { oldValue, newValue in
                    self.pulsate = newValue
                }
                
                Spacer()
                TimersView()
                
                
                Spacer()
                
                
            }
            .padding(.top, 200)
        }
        
        
    }
}




