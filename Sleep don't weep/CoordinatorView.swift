//
//  CoordinatorView.swift
//  Sleep don't weep
//
//  Created by Filip Pokłosiewicz on 27/02/2024.
//

import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State private var isActive = false
   
    var body: some View {
        if isActive {
            ContentView()
        } else {
            IntroView()
        }
    }
}
