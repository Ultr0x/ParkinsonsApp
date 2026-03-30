//
//  EventManager.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 30/03/2026.
//

import SwiftUI
import Observation

@Observable
class EventManager {
    static let shared = EventManager()

    var joinedEventIDs: Set<UUID> = []
    var showConfetti: Bool = false

    func isJoined(_ activityID: UUID) -> Bool {
        joinedEventIDs.contains(activityID)
    }

    func toggleJoin(_ activityID: UUID) {
        if joinedEventIDs.contains(activityID) {
            joinedEventIDs.remove(activityID)
            HapticFeedback.selection()
        } else {
            joinedEventIDs.insert(activityID)
            HapticManager.shared.success()
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showConfetti = false
            }
        }
    }

    func join(_ activityID: UUID) {
        guard !joinedEventIDs.contains(activityID) else { return }
        joinedEventIDs.insert(activityID)
        HapticManager.shared.success()
    }

    var joinedActivities: [PlaceActivity] {
        sampleActivities.filter { joinedEventIDs.contains($0.id) }
            .sorted { $0.date < $1.date }
    }
}
