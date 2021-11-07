//
//  CountDownManager.swift
//  nianfo
//
//  Created by Daxin Chen on 11/6/21.
//

import Foundation

enum CountDownState {
    case started, stopped
}

class CountDownManager : ObservableObject {
    var state = CountDownState.stopped
    
    var timer = Timer()
    
    @Published var remaining = 0
    
    func start(seconds : Int) {
        remaining = seconds
        resume()
    }
    
    func stop() {
        remaining = 0
        pause()
    }
    
    func pause() {
        timer.invalidate()
        state = .stopped
    }

    func setRemaining(remaining: Int) {
        self.remaining = remaining
    }
    
    func resume() {
        state = .started
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.remaining -= 1
            
            if self.remaining <= 0 {
                self.stop()
            }
        }
    }
}
