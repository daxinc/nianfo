//
//  AudioPlayerManager.swift
//  nianfo
//
//  Created by Daxin Chen on 11/6/21.
//

import Foundation
import AVKit

enum PlayerState {
    case stopped, playing, paused
}

class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer
    var playerState : PlayerState
    
    var startTime = 0
    var timeLeft = 0

    // If the play is set to keep playing until being stopped
    var endlessMode = false
    
    override init() {
        let sound = Bundle.main.path(forResource: "fo.m4a", ofType: nil)
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        playerState = PlayerState.stopped
    }
    
    func setState(state: PlayerState) {
        playerState = state
        if state == .playing && !audioPlayer.isPlaying {
            audioPlayer.play()
            audioPlayer.delegate = self
        }
    }
    
    func play(duration: Int) {
        if duration == 0 {
            self.endlessMode = true
        } else {
            self.startTime = Int(Date().timeIntervalSince1970)
            self.timeLeft = duration
        }

        self.audioPlayer.delegate = self
        self.playerState = PlayerState.playing
        
        self.audioPlayer.play()
    }
    
    func pause() {
        self.playerState = PlayerState.paused
    }
    
    func resume() {
        self.playerState = PlayerState.playing
        if !self.audioPlayer.isPlaying {
            self.audioPlayer.play()
        }
    }
    
    func stop() {
        playerState = PlayerState.stopped
    }
    
    func getTimeLeft() -> Int {
        return timeLeft
    }

    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        
        if playerState == .playing {
            player.play()
        }
    }
}
