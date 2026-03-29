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

// MARK: - Onboarding Enums

enum JourneyStage: String, Codable, CaseIterable {
    case recentlyDiagnosed = "Recently diagnosed (0–2 years)"
    case livingWithIt = "Living with it (2–10 years)"
    case longTerm = "Long-term (11+ years)"
    
    var icon: String {
        switch self {
        case .recentlyDiagnosed: return "sunrise.fill"
        case .livingWithIt: return "sun.max.fill"
        case .longTerm: return "moon.stars.fill"
        }
    }
}

enum OutAndAboutExperience: String, Codable, CaseIterable {
    case handsShake = "My hands shake"
    case moveSlowly = "I move slowly or freeze"
    case voiceQuiet = "My voice is quiet / people misread my expression"
    case tiredQuickly = "I get tired quickly"
    case anxiousSocially = "I feel anxious in social situations"
    
    var icon: String {
        switch self {
        case .handsShake: return "hand.raised.fill"
        case .moveSlowly: return "figure.stand"
        case .voiceQuiet: return "speaker.wave.1.fill"
        case .tiredQuickly: return "battery.25"
        case .anxiousSocially: return "person.fill.questionmark"
        }
    }
    
    /// Internal clinical mapping (not shown to user)
    var clinicalMapping: String {
        switch self {
        case .handsShake: return "tremor"
        case .moveSlowly: return "bradykinesia_freezing"
        case .voiceQuiet: return "hypophonia_facial_masking"
        case .tiredQuickly: return "fatigue"
        case .anxiousSocially: return "anxiety_social"
        }
    }
}

enum BodyDistribution: String, Codable, CaseIterable {
    case oneSide = "Mostly one side"
    case bothSides = "Both sides"
    case allOver = "All over"
    
    var icon: String {
        switch self {
        case .oneSide: return "person.fill.turn.left"
        case .bothSides: return "person.2.fill"
        case .allOver: return "figure.arms.open"
        }
    }
}

enum BestTimeOfDay: String, Codable, CaseIterable {
    case morning = "Morning"
    case midday = "Midday"
    case afternoon = "Afternoon"
    case evening = "Evening"
    
    var icon: String {
        switch self {
        case .morning: return "sunrise.fill"
        case .midday: return "sun.max.fill"
        case .afternoon: return "sun.haze.fill"
        case .evening: return "moon.fill"
        }
    }
}

enum SymptomSeverity: String, Codable, CaseIterable {
    case mild = "Mild"
    case moderate = "Moderate"
    case significant = "Significant"
}

enum SymptomSide: String, Codable, CaseIterable {
    case left = "Left side"
    case right = "Right side"
    case both = "Both sides"
    case notApplicable = "N/A"
    
    var icon: String {
        switch self {
        case .left: return "arrow.left"
        case .right: return "arrow.right"
        case .both: return "arrow.left.arrow.right"
        case .notApplicable: return "minus"
        }
    }
}

// MARK: - Onboarding Profile

struct OnboardingProfile: Codable {
    var journeyStage: JourneyStage?
    var experiences: [OutAndAboutExperience]
    var bodyDistribution: BodyDistribution?
    var bestTimeOfDay: BestTimeOfDay?
    
    init() {
        self.experiences = []
    }
}

// MARK: - Detailed Symptom Profile (Profile Layer)

struct SymptomItem: Codable, Identifiable {
    var id: String { key }
    let key: String
    let label: String
    let friendlyDescription: String
    var isEnabled: Bool = false
    var severity: SymptomSeverity? = nil
    var side: SymptomSide? = nil
}

struct SymptomCategory: Codable, Identifiable {
    var id: String { title }
    let title: String
    let icon: String
    var items: [SymptomItem]
}

struct DetailedSymptomProfile: Codable {
    var categories: [SymptomCategory]
    var otherNotes: String
    
    static func defaultProfile() -> DetailedSymptomProfile {
        DetailedSymptomProfile(
            categories: [
                SymptomCategory(title: "Movement", icon: "figure.walk", items: [
                    SymptomItem(key: "tremor", label: "Tremor", friendlyDescription: "Shaking in hands, arms, or legs"),
                    SymptomItem(key: "bradykinesia", label: "Slowness of movement", friendlyDescription: "Taking longer to do everyday tasks"),
                    SymptomItem(key: "rigidity", label: "Rigidity", friendlyDescription: "Stiffness in muscles that makes movement harder"),
                    SymptomItem(key: "instability", label: "Instability", friendlyDescription: "Difficulty keeping balance when standing or walking"),
                    SymptomItem(key: "freezing", label: "Freezing", friendlyDescription: "Feeling like your feet are stuck to the floor"),
                    SymptomItem(key: "falls", label: "Falls", friendlyDescription: "Losing balance and falling"),
                    SymptomItem(key: "dizziness", label: "Dizziness", friendlyDescription: "Feeling dizzy or lightheaded"),
                ]),
                SymptomCategory(title: "Fine Motor", icon: "hand.draw.fill", items: [
                    SymptomItem(key: "micrographia", label: "Small handwriting", friendlyDescription: "Handwriting getting smaller and harder to read"),
                    SymptomItem(key: "dysphagia", label: "Difficulty swallowing", friendlyDescription: "Food or drink going down the wrong way"),
                    SymptomItem(key: "drooling", label: "Drooling", friendlyDescription: "Excess saliva, especially during the day"),
                ]),
                SymptomCategory(title: "Communication", icon: "bubble.left.fill", items: [
                    SymptomItem(key: "hypophonia", label: "Speech changes", friendlyDescription: "Voice getting quieter or slower"),
                    SymptomItem(key: "facial_masking", label: "Facial masking", friendlyDescription: "Face not showing emotions as much as you feel them"),
                ]),
                SymptomCategory(title: "Energy & Comfort", icon: "bolt.fill", items: [
                    SymptomItem(key: "fatigue", label: "Fatigue", friendlyDescription: "Feeling tired even after resting"),
                    SymptomItem(key: "insomnia", label: "Insomnia", friendlyDescription: "Difficulty falling or staying asleep"),
                    SymptomItem(key: "pain", label: "Pain", friendlyDescription: "Aching or cramping in muscles"),
                    SymptomItem(key: "muscle_cramps", label: "Muscle cramps", friendlyDescription: "Sudden painful tightening of muscles"),
                    SymptomItem(key: "sleepiness", label: "Daytime sleepiness", friendlyDescription: "Feeling very sleepy during the day"),
                ]),
                SymptomCategory(title: "Mood & Wellbeing", icon: "heart.fill", items: [
                    SymptomItem(key: "depression", label: "Depression", friendlyDescription: "Feeling low or losing interest in things"),
                    SymptomItem(key: "anxiety", label: "Anxiety", friendlyDescription: "Feeling worried, nervous, or on edge"),
                ]),
            ],
            otherNotes: ""
        )
    }
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

    // Parkinson's Friendly Spaces programme
    // Explicit certification flag (venues that display sticker/beacon and completed staff awareness training)
    var parkinsonsFriendly: Bool = false

    // Optional, for richer UI — not strictly required to compute friendliness
    var displaysBeacon: Bool = false
    var staffAwarenessTraining: Bool = false
    var seatingAvailable: Bool = false
    var calmEnvironment: Bool = false

    // Derived flags
    /// A place hosts events if it has any activities associated with it
    var hostsEvents: Bool { !activityIDs.isEmpty }

    /// Programme rule: Hosting events implies Parkinson’s Friendly certification
    /// Friendly status is true if explicitly certified OR if the place hosts events
    var isParkinsonsFriendly: Bool { parkinsonsFriendly || hostsEvents }
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
    
    // Onboarding data
    var journeyStage: JourneyStage = .livingWithIt
    var experiences: [OutAndAboutExperience] = []
    var bodyDistribution: BodyDistribution = .bothSides
    var bestTimeOfDay: BestTimeOfDay = .morning

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
    var onboarding: OnboardingProfile?
    var detailedSymptoms: DetailedSymptomProfile?
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
