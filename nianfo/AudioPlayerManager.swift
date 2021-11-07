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
    var playerState: PlayerState
    
    // EPOCH time when the player should stop
    var endTime = 0.0
    
    override init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let sound = Bundle.main.path(forResource: "fo.m4a", ofType: nil)
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        playerState = PlayerState.stopped
    }
    
    func play(durationSeconds: Int) {
        // if there's no duration, play indefinitely
        if durationSeconds > 0 {
            endTime = Date().timeIntervalSince1970 + Double(durationSeconds)
        }
        setState(state: .playing)
    }
    
    func setState(state: PlayerState) {
        playerState = state
        
        if state == .playing && !audioPlayer.isPlaying {
            audioPlayer.play()
            audioPlayer.delegate = self
        }
    }
    
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        
        if playerState == .playing {
            if endTime > 1 && endTime < Date().timeIntervalSince1970 {
//                print("stop playing because passed " + String(endTime))
                playerState = .stopped
            } else {
                player.play()
            }
        }
    }
}
