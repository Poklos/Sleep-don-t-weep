//
//  IntroView.swift
//  Sleep don't weep
//
//  Created by Filip Pokłosiewicz on 27/02/2024.
//

import SwiftUI

struct IntroView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            
            if self.isActive {
                ContentView()
            } else {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Text ("""
Sleep
Don't weep
My sweet
Love

- Damien Rice
""")
                    .foregroundStyle(.white)
                    
                }
            }
        }
        .onAppear {
            let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
            if hasLaunchedBefore {
                withAnimation {
                    self.isActive = true
                }
            } else {
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
    
}
