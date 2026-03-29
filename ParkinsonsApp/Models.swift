//
//  Models.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 27/03/2026.
//

import Foundation
import SwiftUI

// MARK: - Enums

enum Stage: String, CaseIterable {
    case early = "Early stage"
    case mid = "Mid stage"
    case advanced = "Advanced stage"
}

enum PlaceCategory: String, CaseIterable {
    case exercise = "Exercise"
    case sport = "Sport"
    case social = "Social"
    case support = "Support Group"
    case boxing = "Boxing"
    case strength = "Strength & Conditioning"
    case cafe = "Café"

    var icon: String {
        switch self {
        case .exercise: return "figure.run"
        case .sport: return "sportscourt.fill"
        case .social: return "cup.and.saucer.fill"
        case .support: return "person.3.fill"
        case .boxing: return "figure.boxing"
        case .strength: return "dumbbell.fill"
        case .cafe: return "mug.fill"
        }
    }

    var color: Color {
        switch self {
        case .exercise: return Theme.cyan
        case .sport: return Theme.green
        case .social: return Theme.orange
        case .support: return Theme.accent
        case .boxing: return Color(hex: 0xE85D75)
        case .strength: return Color(hex: 0x8B5CF6)
        case .cafe: return Theme.orange
        }
    }
}

// MARK: - Community Place (from CSV)

struct CommunityPlace: Identifiable {
    var id = UUID()
    let name: String
    let category: PlaceCategory
    let description: String
    let schedule: String
    let address: String
    let postcode: String
    let latitude: Double
    let longitude: Double
    let link: String?
    let cost: String?
    let accessibility: [String]
    let highlights: [String]
    var memberIDs: [UUID]     // folk who are members/regulars
    var activityIDs: [UUID]   // activities at this place
}

// MARK: - Community Folk (mock people)

struct CommunityFolk: Identifiable {
    var id = UUID()
    let firstName: String
    let lastName: String
    let age: Int
    let diagnosisYear: Int
    let stage: Stage
    let bio: String
    let interests: [String]
    let avatarColor: Color
    var placeIDs: [UUID]      // places they attend

    var initials: String {
        let f = firstName.prefix(1)
        let l = lastName.prefix(1)
        return "\(f)\(l)"
    }

    var yearsSinceDiagnosis: Int {
        Calendar.current.component(.year, from: Date()) - diagnosisYear
    }
}

// MARK: - Place Activity

struct PlaceActivity: Identifiable {
    var id = UUID()
    let name: String
    let description: String
    let date: Date
    let recurrence: String?
    let time: String
    let placeID: UUID
    var participantIDs: [UUID]  // folk attending
}

// MARK: - Legacy models (kept for existing screens)

struct UserProfile {
    var name: String
    var diagnosisYear: Int?
    var approximateStage: Stage
    var interests: [String]
    var companionName: String?
    var milestones: [Milestone]
    var isDiscoverable: Bool
}

struct Milestone: Identifiable {
    var id: String
    var title: String
    var description: String
    var achieved: Bool
    var achievedDate: Date?
}

struct NearbyMember {
    var initial: String
    var yearsSinceDiagnosis: Int
    var stage: Stage
    var sharedInterests: [String]
    var fullName: String
    var groups: [String]
}

// MARK: - Legacy Venue (kept for compatibility, map now uses CommunityPlace)

enum VenueType: String {
    case cafe = "Café"
    case gym = "Gym"
    case park = "Park"
    case cultural = "Cultural"
}

struct TulipVenue: Identifiable {
    var id = UUID()
    var name: String
    var type: VenueType
    var latitude: Double
    var longitude: Double
    var rating: Double
    var accessibility: [String]
    var communityNotes: [String]
    var isCertified: Bool
}

struct TulipEvent: Identifiable {
    var id = UUID()
    var name: String
    var venue: TulipVenue
    var date: Date
    var description: String
    var attendeeCount: Int
    var stageFilter: Stage?
}
