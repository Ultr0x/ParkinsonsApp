//
//  MockData.swift
//  ParkinsonsApp
//
//  Created by Jan Świdziński on 29/03/2026.
//

import Foundation
import SwiftUI

// MARK: - Shared ID references (so we can cross-link places, folk, activities)

// Place IDs
let placeID_exerciseGroup   = UUID()
let placeID_walkingFootball = UUID()
let placeID_camdenMeetup    = UUID()
let placeID_powerUpParkies  = UUID()
let placeID_parkyBlinders   = UUID()
let placeID_wandsworthCafe  = UUID()

// Folk IDs
let folkID_margaret = UUID()
let folkID_david    = UUID()
let folkID_aisha    = UUID()
let folkID_tom      = UUID()
let folkID_priya    = UUID()
let folkID_george   = UUID()
let folkID_helen    = UUID()
let folkID_carlos   = UUID()
let folkID_janet    = UUID()
let folkID_mike     = UUID()

// Activity IDs
let actID_fridayGym       = UUID()
let actID_mondayFootball  = UUID()
let actID_camdenSocial    = UUID()
let actID_thursdayPower   = UUID()
let actID_wedBoxing       = UUID()
let actID_cafeCatchUp     = UUID()
let actID_balanceWorkshop = UUID()
let actID_newMembersWelcome = UUID()

// MARK: - Helper

private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 10, minute: Int = 0) -> Date {
    var c = DateComponents()
    c.year = year; c.month = month; c.day = day; c.hour = hour; c.minute = minute
    return Calendar.current.date(from: c) ?? Date()
}

// MARK: - Community Places (from CSV data)

let samplePlaces: [CommunityPlace] = [
    CommunityPlace(
        id: placeID_exerciseGroup,
        name: "Parkinsons Exercise Group",
        category: .exercise,
        description: "Gym based exercise tailored to your physical ability. The sessions are run by fully qualified instructors who have been specially trained for Parkinson's. Cost per session is \u{00A3}3. Cafe on site acts as a good social meeting place for a chat with friends. Free parking available and easy access by bus. Please allow yourself to arrive promptly for the group to start on time.",
        schedule: "Weekly every Friday, 13:30 - 14:30",
        address: "Southbury Leisure Centre\n192 Southbury Road\nEnfield",
        postcode: "EN1 1YP",
        latitude: 51.6525,
        longitude: -0.0530,
        link: "https://localsupport.parkinsons.org.uk/activity/parkinsons-exercise-group-2",
        cost: "\u{00A3}3 per session",
        accessibility: ["Free parking", "Bus accessible", "On-site cafe"],
        highlights: ["Qualified PD-trained instructors", "All ability levels welcome"],
        memberIDs: [folkID_margaret, folkID_david, folkID_tom, folkID_janet],
        activityIDs: [actID_fridayGym, actID_balanceWorkshop]
    ),
    CommunityPlace(
        id: placeID_walkingFootball,
        name: "Walking Football - Chelsea FC Foundation",
        category: .sport,
        description: "People living with Parkinson's are invited to try walking football sessions from the Chelsea FC Foundation. Supported by the West London Parkinson's Exercise Hub and Imperial College Healthcare NHS Trust. Delivered by specially trained Chelsea FC Foundation coaches on a 3G football pitch, offering a safe, inclusive, and engaging way to stay active through adapted football.",
        schedule: "Weekly every Monday, 10:30 - 11:30",
        address: "Westway Sports Centre (Pitch 2)\n1 Crowthorne Road\nLondon",
        postcode: "W10 6RP",
        latitude: 51.5154,
        longitude: -0.2105,
        link: "https://localsupport.parkinsons.org.uk/activity/walking-football-chelsea-football-club-foundation",
        cost: "Free",
        accessibility: ["3G pitch", "Adapted for PD", "NHS supported"],
        highlights: ["Chelsea FC trained coaches", "Safe & inclusive"],
        memberIDs: [folkID_george, folkID_carlos, folkID_tom, folkID_mike],
        activityIDs: [actID_mondayFootball]
    ),
    CommunityPlace(
        id: placeID_camdenMeetup,
        name: "London Working Age PD Meet-Ups",
        category: .support,
        description: "A group for people of working age affected by Parkinson's. It's an informal group with no fixed agendas. A safe space for people to meet others with Parkinson's and their carers, to share experiences and learn from each other. Usually meets on a weekday from 6pm.",
        schedule: "Monthly (weekday evenings from 18:00)",
        address: "Roundhouse Bar & Cafe\nChalk Farm Road\nCamden Town, London",
        postcode: "NW1 8EH",
        latitude: 51.5432,
        longitude: -0.1520,
        link: "https://localsupport.parkinsons.org.uk/activity/london-working-age-parkinsons-meet-ups-camden",
        cost: "Free",
        accessibility: ["Step-free entrance", "Cafe setting", "Evening sessions"],
        highlights: ["Working age focus", "Informal & welcoming", "Carers welcome"],
        memberIDs: [folkID_aisha, folkID_priya, folkID_helen, folkID_david, folkID_carlos],
        activityIDs: [actID_camdenSocial, actID_newMembersWelcome]
    ),
    CommunityPlace(
        id: placeID_powerUpParkies,
        name: "Power Up Parkies",
        category: .strength,
        description: "Empowerment Through Strength: Improve mobility, balance, and confidence with strength and conditioning training. Safe and supportive environment designed for all abilities. Build strength to maintain daily function, reduce falls, and enhance quality of life. Join a group of like-minded individuals, stay motivated, and have fun while training. Sessions cost \u{00A3}5 per person. Please get in touch before attending.",
        schedule: "Weekly every Thursday, 12:00 - 13:00",
        address: "Charing Cross Sports Club\nAspenlea Road\nLondon",
        postcode: "W6 8LH",
        latitude: 51.4875,
        longitude: -0.2260,
        link: "https://localsupport.parkinsons.org.uk/activity/power-parkies-strength-and-conditioning-training",
        cost: "\u{00A3}5 per session",
        accessibility: ["All abilities", "Supportive coaches"],
        highlights: ["Reduces falls risk", "Builds confidence", "Community atmosphere"],
        memberIDs: [folkID_george, folkID_helen, folkID_mike, folkID_margaret],
        activityIDs: [actID_thursdayPower]
    ),
    CommunityPlace(
        id: placeID_parkyBlinders,
        name: "Parky Blinders (Non-Contact Boxing)",
        category: .boxing,
        description: "Non-contact boxing class run by experienced coaches qualified by Boxing England and Parkinson's UK. Improves motor skills (balance, gait, coordination, agility, reaction time), supports mental and emotional health by reducing anxiety and depression, and supports self-confidence, mood, and mental sharpness. Taught in a supportive, fun, and social environment. Care partners encouraged to participate. Exercises adapted for all mobility levels. Sessions are free. You will need indoor court shoes with a white non-marking sole. Registration required.",
        schedule: "Weekly every Wednesday, 17:00 - 18:00",
        address: "Charing Cross Sports Club\nAspenlea Road\nLondon",
        postcode: "W6 8LH",
        latitude: 51.4875,
        longitude: -0.2260,
        link: nil,
        cost: "Free",
        accessibility: ["All mobility levels", "Steps with railings", "No boxing experience needed"],
        highlights: ["Boxing England qualified", "Care partners welcome", "Mental & physical benefits"],
        memberIDs: [folkID_tom, folkID_carlos, folkID_david, folkID_aisha],
        activityIDs: [actID_wedBoxing]
    ),
    CommunityPlace(
        id: placeID_wandsworthCafe,
        name: "Wandsworth Parkinson's Cafe",
        category: .cafe,
        description: "Join us in an informal setting in the cafe at Battersea Arts Centre for conversation, laughter, friendship and mutual support. No formal activities, just catching up over a cup of tea. We welcome people with Parkinson's, family members, partners, carers, and friends. No cost to attend but you may purchase refreshments from the cafe.",
        schedule: "Monthly on the 3rd Monday, 11:00 - 12:30",
        address: "Battersea Arts Centre\nLavender Hill\nLondon",
        postcode: "SW11 5TN",
        latitude: 51.4621,
        longitude: -0.1710,
        link: "https://localsupport.parkinsons.org.uk/activity/wandsworth-parkinsons-cafe",
        cost: "Free (buy your own refreshments)",
        accessibility: ["Step-free", "Cafe setting", "Family friendly"],
        highlights: ["Informal & relaxed", "Everyone welcome", "Beautiful arts venue"],
        memberIDs: [folkID_janet, folkID_priya, folkID_margaret, folkID_helen, folkID_aisha],
        activityIDs: [actID_cafeCatchUp]
    ),
]

// MARK: - Community Folk (mock people)

let sampleFolk: [CommunityFolk] = [
    CommunityFolk(
        id: folkID_margaret,
        firstName: "Margaret",
        lastName: "Thompson",
        age: 68,
        diagnosisYear: 2020,
        stage: .mid,
        bio: "Retired teacher who loves staying active. Regular at the Friday exercise group and always first to arrive. Enjoys painting watercolours and long walks in the park.",
        interests: ["Exercise", "Painting", "Walking", "Reading"],
        avatarColor: Theme.accent,
        placeIDs: [placeID_exerciseGroup, placeID_powerUpParkies, placeID_wandsworthCafe]
    ),
    CommunityFolk(
        id: folkID_david,
        firstName: "David",
        lastName: "Chen",
        age: 52,
        diagnosisYear: 2023,
        stage: .early,
        bio: "Software developer diagnosed at 50. Passionate about raising awareness for young-onset Parkinson's. Attends the Camden working-age meet-ups regularly.",
        interests: ["Technology", "Boxing", "Photography", "Cooking"],
        avatarColor: Theme.cyan,
        placeIDs: [placeID_exerciseGroup, placeID_camdenMeetup, placeID_parkyBlinders]
    ),
    CommunityFolk(
        id: folkID_aisha,
        firstName: "Aisha",
        lastName: "Patel",
        age: 47,
        diagnosisYear: 2024,
        stage: .early,
        bio: "Marketing consultant and mum of two. Recently diagnosed and finding community support invaluable. Loves the boxing sessions for both the physical and mental boost.",
        interests: ["Boxing", "Yoga", "Coffee", "Travel"],
        avatarColor: Color(hex: 0x8B5CF6),
        placeIDs: [placeID_camdenMeetup, placeID_parkyBlinders, placeID_wandsworthCafe]
    ),
    CommunityFolk(
        id: folkID_tom,
        firstName: "Tom",
        lastName: "Williams",
        age: 61,
        diagnosisYear: 2019,
        stage: .mid,
        bio: "Former PE teacher who never lost his love of sport. You'll find him on the football pitch every Monday and in the boxing ring on Wednesdays. Always encouraging newcomers.",
        interests: ["Football", "Boxing", "Coaching", "Gardening"],
        avatarColor: Theme.green,
        placeIDs: [placeID_exerciseGroup, placeID_walkingFootball, placeID_parkyBlinders]
    ),
    CommunityFolk(
        id: folkID_priya,
        firstName: "Priya",
        lastName: "Sharma",
        age: 55,
        diagnosisYear: 2022,
        stage: .early,
        bio: "Architect who believes in the power of community. Helps organise the Camden meet-ups and is a regular at the Wandsworth cafe. Loves discussing design and art.",
        interests: ["Architecture", "Art", "Community", "Music"],
        avatarColor: Theme.orange,
        placeIDs: [placeID_camdenMeetup, placeID_wandsworthCafe]
    ),
    CommunityFolk(
        id: folkID_george,
        firstName: "George",
        lastName: "Okonkwo",
        age: 58,
        diagnosisYear: 2021,
        stage: .mid,
        bio: "Accountant by trade, footballer at heart. The walking football sessions have been a lifeline. Also attends strength training to keep on top of his fitness.",
        interests: ["Football", "Fitness", "Music", "Chess"],
        avatarColor: Color(hex: 0xE85D75),
        placeIDs: [placeID_walkingFootball, placeID_powerUpParkies]
    ),
    CommunityFolk(
        id: folkID_helen,
        firstName: "Helen",
        lastName: "Murray",
        age: 63,
        diagnosisYear: 2020,
        stage: .mid,
        bio: "Retired nurse who now dedicates her time to supporting others with Parkinson's. A calming presence at every meet-up and always has a kind word.",
        interests: ["Volunteering", "Knitting", "Tea", "Walking"],
        avatarColor: Theme.cyan,
        placeIDs: [placeID_camdenMeetup, placeID_powerUpParkies, placeID_wandsworthCafe]
    ),
    CommunityFolk(
        id: folkID_carlos,
        firstName: "Carlos",
        lastName: "Rivera",
        age: 49,
        diagnosisYear: 2023,
        stage: .early,
        bio: "Chef and restaurant owner. Youngest member of the walking football group. Brings homemade empanadas to the Camden meet-ups. Diagnosed young and determined to stay active.",
        interests: ["Cooking", "Football", "Boxing", "Cycling"],
        avatarColor: Theme.green,
        placeIDs: [placeID_walkingFootball, placeID_camdenMeetup, placeID_parkyBlinders]
    ),
    CommunityFolk(
        id: folkID_janet,
        firstName: "Janet",
        lastName: "Brooks",
        age: 72,
        diagnosisYear: 2018,
        stage: .advanced,
        bio: "The heart of the Friday exercise group. Despite being in advanced stage, Janet's positive attitude inspires everyone. Loves the social side of the cafe meet-ups.",
        interests: ["Exercise", "Socialising", "Baking", "Puzzles"],
        avatarColor: Theme.accent,
        placeIDs: [placeID_exerciseGroup, placeID_wandsworthCafe]
    ),
    CommunityFolk(
        id: folkID_mike,
        firstName: "Mike",
        lastName: "Foster",
        age: 56,
        diagnosisYear: 2022,
        stage: .early,
        bio: "Electrician and lifelong Chelsea fan. Jumped at the chance to join walking football at the Chelsea FC Foundation. Also building strength at Power Up Parkies.",
        interests: ["Football", "DIY", "Strength Training", "Dogs"],
        avatarColor: Color(hex: 0x8B5CF6),
        placeIDs: [placeID_walkingFootball, placeID_powerUpParkies]
    ),
]

// MARK: - Activities

let sampleActivities: [PlaceActivity] = [
    PlaceActivity(
        id: actID_fridayGym,
        name: "Friday Gym Session",
        description: "Tailored gym exercises for all ability levels. Led by Parkinson's-trained instructors. Bring comfortable clothing and water.",
        date: date(2026, 4, 3, hour: 13, minute: 30),
        recurrence: "Weekly every Friday",
        time: "13:30 - 14:30",
        placeID: placeID_exerciseGroup,
        participantIDs: [folkID_margaret, folkID_david, folkID_tom, folkID_janet]
    ),
    PlaceActivity(
        id: actID_mondayFootball,
        name: "Walking Football Match",
        description: "Adapted football on a 3G pitch. Coached by Chelsea FC Foundation staff. All abilities welcome, no experience needed.",
        date: date(2026, 3, 30, hour: 10, minute: 30),
        recurrence: "Weekly every Monday",
        time: "10:30 - 11:30",
        placeID: placeID_walkingFootball,
        participantIDs: [folkID_george, folkID_carlos, folkID_tom, folkID_mike]
    ),
    PlaceActivity(
        id: actID_camdenSocial,
        name: "Camden Monthly Social",
        description: "Informal evening get-together for working-age people with Parkinson's and their carers. No agenda, just good conversation.",
        date: date(2026, 4, 8, hour: 18, minute: 0),
        recurrence: "Monthly",
        time: "18:00 onwards",
        placeID: placeID_camdenMeetup,
        participantIDs: [folkID_aisha, folkID_priya, folkID_helen, folkID_david, folkID_carlos]
    ),
    PlaceActivity(
        id: actID_thursdayPower,
        name: "Strength & Conditioning Session",
        description: "Build strength, improve balance, and maintain daily function. All abilities welcome in a supportive group environment.",
        date: date(2026, 4, 2, hour: 12, minute: 0),
        recurrence: "Weekly every Thursday",
        time: "12:00 - 13:00",
        placeID: placeID_powerUpParkies,
        participantIDs: [folkID_george, folkID_helen, folkID_mike, folkID_margaret]
    ),
    PlaceActivity(
        id: actID_wedBoxing,
        name: "Non-Contact Boxing Class",
        description: "Fun, supportive boxing for all mobility levels. Improves balance, coordination, agility, and mental sharpness. Bring white non-marking sole shoes.",
        date: date(2026, 4, 1, hour: 17, minute: 0),
        recurrence: "Weekly every Wednesday",
        time: "17:00 - 18:00",
        placeID: placeID_parkyBlinders,
        participantIDs: [folkID_tom, folkID_carlos, folkID_david, folkID_aisha]
    ),
    PlaceActivity(
        id: actID_cafeCatchUp,
        name: "Cafe Catch-Up",
        description: "Relaxed social over tea and cake at the beautiful Battersea Arts Centre. Everyone welcome including family and friends.",
        date: date(2026, 4, 20, hour: 11, minute: 0),
        recurrence: "Monthly on the 3rd Monday",
        time: "11:00 - 12:30",
        placeID: placeID_wandsworthCafe,
        participantIDs: [folkID_janet, folkID_priya, folkID_margaret, folkID_helen, folkID_aisha]
    ),
    PlaceActivity(
        id: actID_balanceWorkshop,
        name: "Balance & Falls Prevention Workshop",
        description: "Special workshop focusing on balance exercises and falls prevention techniques. Open to all members of the exercise group.",
        date: date(2026, 4, 10, hour: 13, minute: 30),
        recurrence: nil,
        time: "13:30 - 15:00",
        placeID: placeID_exerciseGroup,
        participantIDs: [folkID_margaret, folkID_janet, folkID_tom]
    ),
    PlaceActivity(
        id: actID_newMembersWelcome,
        name: "New Members Welcome Evening",
        description: "A special evening to welcome anyone recently diagnosed or new to the community. Hear from existing members and ask questions in a safe space.",
        date: date(2026, 4, 15, hour: 18, minute: 0),
        recurrence: nil,
        time: "18:00 - 19:30",
        placeID: placeID_camdenMeetup,
        participantIDs: [folkID_aisha, folkID_priya, folkID_helen]
    ),
]

// MARK: - Helper lookups

func folkFor(id: UUID) -> CommunityFolk? {
    sampleFolk.first { $0.id == id }
}

func placeFor(id: UUID) -> CommunityPlace? {
    samplePlaces.first { $0.id == id }
}

func activitiesFor(placeID: UUID) -> [PlaceActivity] {
    sampleActivities.filter { $0.placeID == placeID }
}

func placesFor(folkID: UUID) -> [CommunityPlace] {
    samplePlaces.filter { $0.memberIDs.contains(folkID) }
}

func activitiesFor(folkID: UUID) -> [PlaceActivity] {
    sampleActivities.filter { $0.participantIDs.contains(folkID) }
}

// MARK: - Legacy sample data (for existing screens)

let sampleMilestones = [
    Milestone(id: "1", title: "First carry", description: "Carried the Stigma charm", achieved: true, achievedDate: Date()),
    Milestone(id: "2", title: "First hello", description: "Matched using proximity", achieved: false, achievedDate: nil),
    Milestone(id: "3", title: "Joined an event", description: "Attended a Stigma community event", achieved: false, achievedDate: nil)
]

let sampleUser = UserProfile(
    name: "Jan",
    diagnosisYear: 2024,
    approximateStage: .early,
    interests: ["Photography", "Walking", "Tech"],
    companionName: "Sarah",
    milestones: sampleMilestones,
    isDiscoverable: true
)

let sampleMatch = NearbyMember(
    initial: "J.",
    yearsSinceDiagnosis: 2,
    stage: .early,
    sharedInterests: ["Hiking", "Boxing"],
    fullName: "James",
    groups: ["Rock Steady Boxing Brixton"]
)

let sampleVenues = [
    TulipVenue(
        name: "The Greenhouse",
        type: .cafe,
        latitude: 51.5074,
        longitude: -0.1278,
        rating: 4.6,
        accessibility: ["Step-free", "Quiet", "Patient staff"],
        communityNotes: ["Great corner table", "Staff know about PD"],
        isCertified: true
    ),
    TulipVenue(
        name: "Rock Steady Boxing",
        type: .gym,
        latitude: 51.4620,
        longitude: -0.1159,
        rating: 4.9,
        accessibility: ["Step-free", "PD-specific classes"],
        communityNotes: ["Thursday class is best for beginners"],
        isCertified: true
    ),
    TulipVenue(
        name: "Brockwell Park",
        type: .park,
        latitude: 51.4500,
        longitude: -0.1063,
        rating: 4.3,
        accessibility: ["Smooth paths", "Benches every 100m"],
        communityNotes: ["Tuesday walking group meets at café"],
        isCertified: false
    )
]
