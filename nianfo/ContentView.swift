//
//  ContentView.swift
//  nianfo
//
//  Created by Daxin Chen on 11/5/21.
//

import SwiftUI

struct ContentView: View {
    @State var player = AudioPlayerManager()
    @ObservedObject var countDownManager = CountDownManager()

    @State var playerState = PlayerState.stopped

    // how many seconds left before audio stops
    @State var secondsLeft = 0

    @State var sessionDurationMinutes = 60
    @State var eternalSessionDuration = false
    
    @State var configurationMode = false
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            if configurationMode {
                VStack {
                    Text("Choose session time (Minutes)")
                    
                    HStack {
                        Button("5") {
                            configure(sessionDurationMinutes: 5)
                        }
                        .frame(width: 25, height: 20)
                        
                        Button("15") {
                            configure(sessionDurationMinutes: 15)
                        }
                        .frame(width: 25, height: 20)
                        
                        Button("30") {
                            configure(sessionDurationMinutes: 30)
                        }
                        .frame(width: 25, height: 20)
                        
                        Button("45") {
                            configure(sessionDurationMinutes: 45)
                        }
                        .frame(width: 25, height: 20)
                        
                        Button("60") {
                            configure(sessionDurationMinutes: 60)
                        }
                        .frame(width: 25, height: 20)
                        
                        Button("75") {
                            configure(sessionDurationMinutes: 75)
                        }
                        .frame(width: 25, height: 20)
                        
                        Button("∞") {
                            configure(sessionDurationMinutes: -1)
                        }
                        .frame(width: 25, height: 20)
                    }
                }
            } else {
                Text(getRemainingTimeText())
                    .padding()
                .accessibilityIdentifier("remaining-time")
                
                HStack {
                    Button("Start") {
                        play()
                    }
                    .frame(width: 80, height: 20)
                    .disabled(playerState == .playing || playerState == .paused)
                    
                    Button(getPauseResumeButtonText()) {
                        pauseOrResume()
                    }
                    .frame(width: 80, height: 20)
                    .disabled(playerState == .stopped)
                    
                    Button("Stop") {
                        stop()
                    }
                    .frame(width: 80, height: 20)
                    .disabled(playerState == .stopped)
                    
                    Button("Setting") {
                        configurationMode = true
                    }
                    .frame(width: 80, height: 20)
                    .disabled(playerState != .stopped)
                }
            }
        }
    }
    
    func configure(sessionDurationMinutes: Int) {
        configurationMode = false
        if sessionDurationMinutes == -1 {
            eternalSessionDuration = true
        } else {
            self.sessionDurationMinutes = sessionDurationMinutes
            eternalSessionDuration = false
        }
    }
    
    func play() {
        player.setState(state: .playing)
        playerState = .playing
        
        if !eternalSessionDuration {
            countDownManager.start(seconds: sessionDurationMinutes * 60)
        }
    }
    
    func pauseOrResume() {
        // resume
        if playerState == .paused {
            playerState = .playing
            player.setState(state: .playing)
            if !eternalSessionDuration {
                countDownManager.resume()
            }
        }

        // pause
        else if playerState == .playing {
            playerState = .paused
            player.setState(state: .paused)
            
            if !eternalSessionDuration {
                countDownManager.pause()
            }
        }
    }
    
    func stop() {
        playerState = .stopped
        player.setState(state: .stopped)
        
        if !eternalSessionDuration {
            countDownManager.stop()
        }
    }
    
    func getPauseResumeButtonText() -> String {
        if self.playerState == .paused {
            return "Resume"
        }

        return "Pause"
    }
    
    func getRemainingTimeText() -> String {
        if eternalSessionDuration {
            return "∞"
        }
        
        let sec : Int

        if playerState == .stopped {
            sec = sessionDurationMinutes * 60
        } else {
            sec = countDownManager.remaining
        }
        
        return paddingZeroIfNecessary(n: sec / 3600) + ":" + paddingZeroIfNecessary(n: (sec % 3600) / 60) + ":" + paddingZeroIfNecessary(n: (sec % 3600) % 60)
    }
    
    private func paddingZeroIfNecessary(n: Int) -> String {
        if n < 10 {
            return "0" + String(n)
        }
        
        return String(n)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
