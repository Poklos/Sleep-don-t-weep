//
//  TimersView.swift
//  Sleep don't weep
//
//  Created by Filip Pokłosiewicz on 20/03/2024.
//


import SwiftUI

struct TimersView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    
    private let timeIntervals: [Int] = [15, 30, 45, 60]
    
    //   init(audioPlayer: AudioPlayer) {
    //         self.audioPlayer = audioPlayer
    //        self._timersViewModel = StateObject(wrappedValue: TimersViewModel(audioPlayer: audioPlayer))
    //      }
    
    var body: some View {
        
        HStack(spacing: 30) {
            ForEach(timeIntervals, id: \.self) { minute in
                Button(action: {
                    viewModel.startTimer(duration: TimeInterval(minute * 60))
                }) {
                    Text(minute == 60 ? "1 h" : "\(minute)")
                        .foregroundStyle(.white)
                        .whiteTextWithCircularBorder()
                }
            }
        }
        
    }
    
}


extension Text {
    func whiteTextWithCircularBorder() -> some View {
        self
            .padding()
            .background(Circle().stroke(Color.white, lineWidth: 1))
            .foregroundColor(.white)
    }
}
