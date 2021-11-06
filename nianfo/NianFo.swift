//
//  nianfoApp.swift
//  nianfo
//
//  Created by Daxin Chen on 11/5/21.
//

import SwiftUI

@main
struct NianFo: App {
    var body: some Scene {
        WindowGroup {
            ContentView(player: AudioPlayerManager())
        }
    }
}
