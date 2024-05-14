//
//  AppViewModel.swift
//  Sleep don't weep
//
//  Created by Filip Pokłosiewicz on 21/03/2024.
//
import SwiftUI
import Foundation
import AVFoundation

class AppViewModel: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var remainingTime: TimeInterval? 
    var timer: Timer?

    init() {
        // Inicjalizacja odtwarzacza audio
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }

        if let asset = NSDataAsset(name: "thesound") {
            do {
                self.audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
                self.audioPlayer?.numberOfLoops = -1
            } catch {
                print("AVAudioPlayer could not be instantiated.", error)
            }
        } else {
            print("Audio file could not be found.")
        }
    }

    func playOrPause() {
        guard let player = audioPlayer else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
            // Zatrzymaj timer i wyczyść remainingTime
            timer?.invalidate()
            remainingTime = nil
        } else {
            player.play()
            isPlaying = true
            // Tutaj możesz opcjonalnie rozpocząć timer na nowo, jeśli to potrzebne
        }
    }
    
    func startFadeOut(duration: TimeInterval, completion: @escaping () -> Void) {
        let fadeOutSteps = Int(duration * 20)
        let fadeOutStepInterval = duration / TimeInterval(fadeOutSteps)
        var stepsDone = 0

        for step in 0..<fadeOutSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutStepInterval * TimeInterval(step)) {
                guard let player = self.audioPlayer else { return }
                
                let volumeDecrease = player.volume / Float(fadeOutSteps)
                player.volume -= volumeDecrease
                
                stepsDone += 1
                if stepsDone >= fadeOutSteps {
                    completion()
                }
            }
        }
    }


    func startTimer(duration: TimeInterval) {
        timer?.invalidate()  // Unieważnij istniejący timer
        remainingTime = duration

        if !isPlaying {
            playOrPause()
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if let remaining = self.remainingTime, remaining > 0 {
                self.remainingTime! -= 1
                
                if remaining == 50 {  // Rozpocznij fade-out 30 sekund przed końcem
                    self.startFadeOut(duration: 50) {
                        DispatchQueue.main.async {
                            self.audioPlayer?.stop()
                            self.audioPlayer?.volume = 1.0  // Przywróć początkową głośność na przyszłe odtwarzanie
                            self.isPlaying = false
                            self.timer?.invalidate()
                            self.remainingTime = nil
                        }
                    }
                }
            }
        }
    }


}
