//
//  ParkinsonsAppApp.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

@main
struct ParkinsonsAppApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var splashFinished = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasCompletedOnboarding {
                    ContentView()
                } else {
                    OnboardingView()
                }

                if !splashFinished {
                    SplashScreen(isFinished: $splashFinished)
                        .zIndex(999)
                }
            }
        }
    }
}
