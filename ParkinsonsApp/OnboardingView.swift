//
//  OnboardingView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    @State private var step = 0
    @State private var name: String = ""
    @State private var isAnimatingAsterisk = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            TabView(selection: $step) {
                welcomeScreen.tag(0)
                aboutYouScreen.tag(1)
                readyScreen.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: step)
        }
        .preferredColorScheme(.light)
    }
    
    private var welcomeScreen: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "asterisk")
                .font(.system(size: 80, weight: .bold))
                .foregroundStyle(Theme.accent)
            
            VStack(spacing: 16) {
                Text("Welcome to Stigma")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundStyle(Theme.text)
                
                Text("A community for people navigating life with invisible challenges.")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Theme.text.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button {
                step = 1
            } label: {
                Text("Get started")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Theme.text)
                    .foregroundStyle(Theme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
    
    private var aboutYouScreen: some View {
        VStack(alignment: .leading, spacing: 32) {
            Image(systemName: "asterisk")
                .font(.title)
                .foregroundStyle(Theme.accent)
                .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What should we call you?")
                    .font(.title.weight(.heavy))
                    .foregroundStyle(Theme.text)
                
                TextField("Your first name", text: $name)
                    .font(.title3)
                    .padding()
                    .background(Theme.glassBackground)
                    .foregroundStyle(Theme.text)
            }
            
            Spacer()
            
            Button {
                step = 2
            } label: {
                Text("Continue")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(name.isEmpty ? Theme.text.opacity(0.3) : Theme.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .disabled(name.isEmpty)
            .padding(.bottom, 48)
        }
        .padding(.horizontal, 24)
    }
    
    private var readyScreen: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("You're in. Here's your tulip.")
                .font(.title.weight(.heavy))
                .foregroundStyle(Theme.text)
            
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimatingAsterisk ? 1.1 : 1.0)
                
                Image(systemName: "asterisk")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(Theme.accent)
                    .rotationEffect(.degrees(isAnimatingAsterisk ? 15 : 0))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimatingAsterisk = true
                }
            }
            
            Text("Carry it with pride — or keep it secret.\nBoth are valid.")
                .font(.headline.weight(.medium))
                .foregroundStyle(Theme.text.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            Button {
                hasCompletedOnboarding = true
            } label: {
                Text("Enter Stigma")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Theme.text)
                    .foregroundStyle(Theme.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
}

#Preview {
    OnboardingView()
}
