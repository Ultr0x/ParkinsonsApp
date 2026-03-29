//
//  ProfileView.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header

                    TulipCard(title: "Conditions & symptoms", accent: Theme.tulipOrange) {
                        Text("Add or update your health info")
                    }

                    TulipCard(title: "Bio", accent: Theme.tulipCyan) {
                        Text("Short description about you")
                    }

                    TulipCard(title: "My clubs", accent: Theme.tulipGreen) {
                        Text("Clubs you’ve joined")
                    }

                    TulipCard(title: "Interests", accent: Theme.tulipPurple) {
                        Text("Choose interests to personalize")
                    }

                    TulipCard(title: "Recent activity", accent: Theme.tulipPink) {
                        Text("Events attended, posts, groups")
                    }
                }
                .padding(16)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Profile")
            .toolbarBackground(Theme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .preferredColorScheme(.light)
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.cardBackground(for: Theme.tulipPink))
                Image(systemName: "person.fill")
                    .foregroundStyle(Theme.tulipPink)
                    .font(.title2)
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text("Your Name")
                    .font(.title3).bold()
                    .foregroundStyle(Theme.text)
                Text("Member since 2026")
                    .foregroundStyle(Theme.text.opacity(0.7))
            }

            Spacer()
        }
    }
}

#Preview {
    ProfileView()
}
