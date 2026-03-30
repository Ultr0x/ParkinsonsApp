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
let actID_tuesdayYoga     = UUID()
let actID_saturdayCoffee  = UUID()
let actID_sundayWalk      = UUID()
let actID_fridayGym2      = UUID()
let actID_mondayFootball2 = UUID()
let actID_wedBoxing2      = UUID()
let actID_thursdayPower2  = UUID()
let actID_artWorkshop     = UUID()
let actID_gardenParty     = UUID()
let actID_musicSession    = UUID()

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
        name: "Adaptive Exercise Group",
        category: .exercise,
        description: "Gym based exercise tailored to your physical ability. The sessions are run by fully qualified instructors trained in working with movement difficulties and neurological conditions. Cost per session is \u{00A3}3. Cafe on site acts as a good social meeting place for a chat with friends. Free parking available and easy access by bus. Please allow yourself to arrive promptly for the group to start on time.",
        schedule: "Weekly every Friday, 13:30 - 14:30",
        address: "Southbury Leisure Centre\n192 Southbury Road\nEnfield",
        postcode: "EN1 1YP",
        latitude: 51.6525,
        longitude: -0.0530,
        link: nil,
        cost: "\u{00A3}3 per session",
        accessibility: ["Free parking", "Bus accessible", "On-site cafe"],
        highlights: ["Trained in neurological conditions", "All ability levels welcome"],
        memberIDs: [folkID_margaret, folkID_david, folkID_tom, folkID_janet],
        activityIDs: [actID_fridayGym, actID_balanceWorkshop],
        tulipCertified: true,
        displaysBeacon: true,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: true,
        communityVerified: true
    ),
    CommunityPlace(
        id: placeID_walkingFootball,
        name: "Walking Football - Chelsea FC Foundation",
        category: .sport,
        description: "Walking football sessions from the Chelsea FC Foundation. Delivered by specially trained coaches on a 3G football pitch, offering a safe, inclusive, and engaging way to stay active through adapted football. Open to anyone with movement challenges or neurological conditions.",
        schedule: "Weekly every Monday, 10:30 - 11:30",
        address: "Westway Sports Centre (Pitch 2)\n1 Crowthorne Road\nLondon",
        postcode: "W10 6RP",
        latitude: 51.5154,
        longitude: -0.2105,
        link: nil,
        cost: "Free",
        accessibility: ["3G pitch", "Adapted exercises", "NHS supported"],
        highlights: ["Chelsea FC trained coaches", "Safe & inclusive"],
        memberIDs: [folkID_george, folkID_carlos, folkID_tom, folkID_mike],
        activityIDs: [actID_mondayFootball],
        tulipCertified: true,
        displaysBeacon: false,
        staffAwarenessTraining: true,
        seatingAvailable: false,
        calmEnvironment: true,
        communityVerified: true
    ),
    CommunityPlace(
        id: placeID_camdenMeetup,
        name: "London Working Age Meet-Ups",
        category: .support,
        description: "A group for working-age people living with invisible challenges — tremors, fatigue, mobility issues, and more. It's an informal group with no fixed agendas. A safe space to meet others who understand, share experiences, and learn from each other. Usually meets on a weekday from 6pm.",
        schedule: "Monthly (weekday evenings from 18:00)",
        address: "Roundhouse Bar & Cafe\nChalk Farm Road\nCamden Town, London",
        postcode: "NW1 8EH",
        latitude: 51.5432,
        longitude: -0.1520,
        link: nil,
        cost: "Free",
        accessibility: ["Step-free entrance", "Cafe setting", "Evening sessions"],
        highlights: ["Working age focus", "Informal & welcoming", "Carers welcome"],
        memberIDs: [folkID_aisha, folkID_priya, folkID_helen, folkID_david, folkID_carlos],
        activityIDs: [actID_camdenSocial, actID_newMembersWelcome],
        tulipCertified: false,
        displaysBeacon: true,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: true
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
        link: nil,
        cost: "\u{00A3}5 per session",
        accessibility: ["All abilities", "Supportive coaches"],
        highlights: ["Reduces falls risk", "Builds confidence", "Community atmosphere"],
        memberIDs: [folkID_george, folkID_helen, folkID_mike, folkID_margaret],
        activityIDs: [actID_thursdayPower],
        tulipCertified: false,
        displaysBeacon: false,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: true
    ),
    CommunityPlace(
        id: placeID_parkyBlinders,
        name: "Parky Blinders (Non-Contact Boxing)",
        category: .boxing,
        description: "Non-contact boxing class run by experienced coaches qualified by Boxing England. Improves motor skills (balance, gait, coordination, agility, reaction time), supports mental and emotional health by reducing anxiety and depression, and builds self-confidence, mood, and mental sharpness. Taught in a supportive, fun, and social environment. Care partners encouraged to participate. Exercises adapted for all mobility levels. Sessions are free. You will need indoor court shoes with a white non-marking sole. Registration required.",
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
        activityIDs: [actID_wedBoxing],
        tulipCertified: false,
        displaysBeacon: false,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: true
    ),
    CommunityPlace(
        id: placeID_wandsworthCafe,
        name: "Wandsworth Community Cafe",
        category: .cafe,
        description: "Join us in an informal setting in the cafe at Battersea Arts Centre for conversation, laughter, friendship and mutual support. No formal activities, just catching up over a cup of tea. We welcome people with invisible challenges, family members, partners, carers, and friends. No cost to attend but you may purchase refreshments from the cafe.",
        schedule: "Monthly on the 3rd Monday, 11:00 - 12:30",
        address: "Battersea Arts Centre\nLavender Hill\nLondon",
        postcode: "SW11 5TN",
        latitude: 51.4621,
        longitude: -0.1710,
        link: nil,
        cost: "Free (buy your own refreshments)",
        accessibility: ["Step-free", "Cafe setting", "Family friendly"],
        highlights: ["Informal & relaxed", "Everyone welcome", "Beautiful arts venue"],
        memberIDs: [folkID_janet, folkID_priya, folkID_margaret, folkID_helen, folkID_aisha],
        activityIDs: [actID_cafeCatchUp],
        tulipCertified: true,
        displaysBeacon: true,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: true,
        communityVerified: true
    ),
    // MARK: - Friendly-Only Spaces (no events hosted)
    CommunityPlace(
        name: "Costa Coffee - King's Cross",
        category: .cafe,
        description: "A large Costa Coffee branch near King's Cross station. Staff have completed accessibility awareness training and the environment is calm with plenty of comfortable seating. Community members regularly meet here informally.",
        schedule: "Daily 06:00 - 22:00",
        address: "1 Pancras Square\nKing's Cross\nLondon",
        postcode: "N1C 4AG",
        latitude: 51.5333,
        longitude: -0.1240,
        link: nil,
        cost: nil,
        accessibility: ["Step-free", "Accessible toilets", "Quiet area available"],
        highlights: ["Staff trained", "Comfortable seating", "Near station"],
        memberIDs: [],
        activityIDs: [],
        tulipCertified: true,
        displaysBeacon: true,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: true,
        communityVerified: true
    ),
    CommunityPlace(
        name: "Pret A Manger - Waterloo",
        category: .cafe,
        description: "Pret near Waterloo station. Staff are patient and understanding. Wide aisles and comfortable seating make it a good spot for people who need a bit more time. Added to the map by community members.",
        schedule: "Mon-Fri 06:00-21:00, Sat-Sun 07:00-20:00",
        address: "97 Waterloo Road\nLambeth\nLondon",
        postcode: "SE1 8UL",
        latitude: 51.5035,
        longitude: -0.1130,
        link: nil,
        cost: nil,
        accessibility: ["Step-free entrance", "Wide aisles"],
        highlights: ["Patient staff", "Comfortable seating"],
        memberIDs: [],
        activityIDs: [],
        tulipCertified: true,
        displaysBeacon: false,
        staffAwarenessTraining: false,
        seatingAvailable: true,
        calmEnvironment: true,
        communityVerified: true
    ),
    CommunityPlace(
        name: "Tesco Extra - Surrey Quays",
        category: .social,
        description: "Large Tesco Extra with wide aisles, accessible checkouts, and an in-store café. Staff have completed accessibility awareness sessions. A good place to shop at quieter times.",
        schedule: "Mon-Sat 06:00-00:00, Sun 10:00-16:00",
        address: "Redriff Road\nSurrey Quays\nLondon",
        postcode: "SE16 7LL",
        latitude: 51.4938,
        longitude: -0.0480,
        link: nil,
        cost: nil,
        accessibility: ["Wide aisles", "Accessible checkouts", "In-store café"],
        highlights: ["Quiet shopping hours", "Staff aware"],
        memberIDs: [],
        activityIDs: [],
        tulipCertified: true,
        displaysBeacon: false,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: false
    ),
    CommunityPlace(
        name: "Greenleaf Pharmacy - Brixton",
        category: .support,
        description: "An independent pharmacy with knowledgeable staff who understand complex medication needs. They're happy to take extra time with customers and offer a seated waiting area.",
        schedule: "Mon-Fri 09:00-18:00, Sat 09:00-13:00",
        address: "45 Brixton Hill\nBrixton\nLondon",
        postcode: "SW2 1JG",
        latitude: 51.4530,
        longitude: -0.1150,
        link: nil,
        cost: nil,
        accessibility: ["Step-free", "Seated waiting area"],
        highlights: ["Complex medication expertise", "Patient staff"],
        memberIDs: [],
        activityIDs: [],
        tulipCertified: true,
        displaysBeacon: true,
        staffAwarenessTraining: true,
        seatingAvailable: true,
        calmEnvironment: true
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
        interests: [.exercise, .painting, .walking, .reading],
        avatarColor: Theme.accent,
        placeIDs: [placeID_exerciseGroup, placeID_powerUpParkies, placeID_wandsworthCafe],
        isDiscoverable: false,
        journeyStage: .livingWithIt,
        experiences: [.handsShake, .tiredQuickly],
        bodyDistribution: .oneSide,
        bestTimeOfDay: .morning
    ),
    CommunityFolk(
        id: folkID_david,
        firstName: "David",
        lastName: "Chen",
        age: 52,
        diagnosisYear: 2023,
        stage: .early,
        bio: "Software developer diagnosed with essential tremor at 50. Passionate about raising awareness for invisible challenges. Attends the Camden working-age meet-ups regularly.",
        interests: [.technology, .boxing, .photography, .cooking],
        avatarColor: Theme.cyan,
        placeIDs: [placeID_exerciseGroup, placeID_camdenMeetup, placeID_parkyBlinders],
        isDiscoverable: true,
        journeyStage: .recentlyDiagnosed,
        experiences: [.handsShake, .anxiousSocially],
        bodyDistribution: .oneSide,
        bestTimeOfDay: .morning
    ),
    CommunityFolk(
        id: folkID_aisha,
        firstName: "Aisha",
        lastName: "Patel",
        age: 47,
        diagnosisYear: 2024,
        stage: .early,
        bio: "Marketing consultant and mum of two. Recently diagnosed and finding community support invaluable. Loves the boxing sessions for both the physical and mental boost.",
        interests: [.boxing, .yoga, .coffee, .travel],
        avatarColor: Color(hex: 0x8B5CF6),
        placeIDs: [placeID_camdenMeetup, placeID_parkyBlinders, placeID_wandsworthCafe],
        isDiscoverable: false,
        journeyStage: .recentlyDiagnosed,
        experiences: [.anxiousSocially, .tiredQuickly],
        bodyDistribution: .oneSide,
        bestTimeOfDay: .midday
    ),
    CommunityFolk(
        id: folkID_tom,
        firstName: "Tom",
        lastName: "Williams",
        age: 61,
        diagnosisYear: 2019,
        stage: .mid,
        bio: "Former PE teacher who never lost his love of sport. You'll find him on the football pitch every Monday and in the boxing ring on Wednesdays. Always encouraging newcomers.",
        interests: [.football, .boxing, .volunteering, .gardening],
        avatarColor: Theme.green,
        placeIDs: [placeID_exerciseGroup, placeID_walkingFootball, placeID_parkyBlinders],
        isDiscoverable: true,
        journeyStage: .livingWithIt,
        experiences: [.moveSlowly, .handsShake, .tiredQuickly],
        bodyDistribution: .bothSides,
        bestTimeOfDay: .morning
    ),
    CommunityFolk(
        id: folkID_priya,
        firstName: "Priya",
        lastName: "Sharma",
        age: 55,
        diagnosisYear: 2022,
        stage: .early,
        bio: "Architect who believes in the power of community. Helps organise the Camden meet-ups and is a regular at the Wandsworth cafe. Loves discussing design and art.",
        interests: [.art, .painting, .socialising, .music],
        avatarColor: Theme.orange,
        placeIDs: [placeID_camdenMeetup, placeID_wandsworthCafe],
        isDiscoverable: false,
        journeyStage: .recentlyDiagnosed,
        experiences: [.voiceQuiet, .anxiousSocially],
        bodyDistribution: .oneSide,
        bestTimeOfDay: .afternoon
    ),
    CommunityFolk(
        id: folkID_george,
        firstName: "George",
        lastName: "Okonkwo",
        age: 58,
        diagnosisYear: 2021,
        stage: .mid,
        bio: "Accountant by trade, footballer at heart. The walking football sessions have been a lifeline. Also attends strength training to keep on top of his fitness.",
        interests: [.football, .exercise, .music, .puzzles],
        avatarColor: Color(hex: 0xE85D75),
        placeIDs: [placeID_walkingFootball, placeID_powerUpParkies],
        isDiscoverable: false,
        journeyStage: .livingWithIt,
        experiences: [.moveSlowly, .tiredQuickly],
        bodyDistribution: .bothSides,
        bestTimeOfDay: .midday
    ),
    CommunityFolk(
        id: folkID_helen,
        firstName: "Helen",
        lastName: "Murray",
        age: 63,
        diagnosisYear: 2020,
        stage: .mid,
        bio: "Retired nurse who now dedicates her time to supporting others in the community. A calming presence at every meet-up and always has a kind word.",
        interests: [.volunteering, .nature, .coffee, .walking],
        avatarColor: Theme.cyan,
        placeIDs: [placeID_camdenMeetup, placeID_powerUpParkies, placeID_wandsworthCafe],
        isDiscoverable: true,
        journeyStage: .livingWithIt,
        experiences: [.tiredQuickly, .voiceQuiet],
        bodyDistribution: .allOver,
        bestTimeOfDay: .morning
    ),
    CommunityFolk(
        id: folkID_carlos,
        firstName: "Carlos",
        lastName: "Rivera",
        age: 49,
        diagnosisYear: 2023,
        stage: .early,
        bio: "Chef and restaurant owner. Youngest member of the walking football group. Brings homemade empanadas to the Camden meet-ups. Diagnosed young and determined to stay active.",
        interests: [.cooking, .football, .boxing, .cycling],
        avatarColor: Theme.green,
        placeIDs: [placeID_walkingFootball, placeID_camdenMeetup, placeID_parkyBlinders],
        isDiscoverable: false,
        journeyStage: .recentlyDiagnosed,
        experiences: [.handsShake, .moveSlowly],
        bodyDistribution: .oneSide,
        bestTimeOfDay: .afternoon
    ),
    CommunityFolk(
        id: folkID_janet,
        firstName: "Janet",
        lastName: "Brooks",
        age: 72,
        diagnosisYear: 2018,
        stage: .advanced,
        bio: "The heart of the Friday exercise group. Despite being in advanced stage, Janet's positive attitude inspires everyone. Loves the social side of the cafe meet-ups.",
        interests: [.exercise, .socialising, .baking, .puzzles],
        avatarColor: Theme.accent,
        placeIDs: [placeID_exerciseGroup, placeID_wandsworthCafe],
        isDiscoverable: false,
        journeyStage: .longTerm,
        experiences: [.moveSlowly, .handsShake, .tiredQuickly, .voiceQuiet],
        bodyDistribution: .allOver,
        bestTimeOfDay: .morning
    ),
    CommunityFolk(
        id: folkID_mike,
        firstName: "Mike",
        lastName: "Foster",
        age: 56,
        diagnosisYear: 2022,
        stage: .early,
        bio: "Electrician and lifelong Chelsea fan. Jumped at the chance to join walking football at the Chelsea FC Foundation. Also building strength at Power Up Parkies.",
        interests: [.football, .technology, .strengthTraining, .dogs],
        avatarColor: Color(hex: 0x8B5CF6),
        placeIDs: [placeID_walkingFootball, placeID_powerUpParkies],
        isDiscoverable: false,
        journeyStage: .recentlyDiagnosed,
        experiences: [.handsShake, .tiredQuickly],
        bodyDistribution: .oneSide,
        bestTimeOfDay: .midday
    ),
]

// MARK: - Activities

let sampleActivities: [PlaceActivity] = [
    // MARK: Week of 30 Mar (current week)
    PlaceActivity(
        id: actID_mondayFootball,
        name: "Walking Football Match",
        description: "Adapted football on a 3G pitch. Coached by Chelsea FC Foundation staff. All abilities welcome, no experience needed. Warm up at 10:15, match kicks off at 10:30.",
        date: date(2026, 3, 30, hour: 10, minute: 30),
        recurrence: "Weekly every Monday",
        time: "10:30 - 11:30",
        placeID: placeID_walkingFootball,
        participantIDs: [folkID_george, folkID_carlos, folkID_tom, folkID_mike],
        photos: [
            EventPhoto(icon: "soccerball", colors: [Color(hex: 0x4CAF50), Color(hex: 0x2E7D32)], caption: "On the 3G pitch"),
            EventPhoto(icon: "figure.walk", colors: [Color(hex: 0x66BB6A), Color(hex: 0x388E3C)], caption: "Warm-up session"),
            EventPhoto(icon: "sportscourt.fill", colors: [Color(hex: 0x81C784), Color(hex: 0x43A047)], caption: "Match day"),
        ]
    ),
    PlaceActivity(
        id: actID_tuesdayYoga,
        name: "Morning Yoga & Stretch",
        description: "Gentle yoga adapted for people with movement challenges. Focus on balance, flexibility, and deep breathing. Chair options available throughout. Mats provided or bring your own.",
        date: date(2026, 3, 31, hour: 9, minute: 30),
        recurrence: "Weekly every Tuesday",
        time: "09:30 - 10:30",
        placeID: placeID_powerUpParkies,
        participantIDs: [folkID_helen, folkID_priya, folkID_margaret, folkID_aisha],
        photos: [
            EventPhoto(icon: "figure.mind.and.body", colors: [Color(hex: 0xCE93D8), Color(hex: 0x8E24AA)], caption: "Gentle stretches"),
            EventPhoto(icon: "leaf.fill", colors: [Color(hex: 0xA5D6A7), Color(hex: 0x43A047)], caption: "Calm environment"),
        ]
    ),
    PlaceActivity(
        id: actID_wedBoxing,
        name: "Non-Contact Boxing Class",
        description: "Fun, supportive boxing for all mobility levels. Improves balance, coordination, agility, and mental sharpness. Bring white non-marking sole shoes.",
        date: date(2026, 4, 1, hour: 17, minute: 0),
        recurrence: "Weekly every Wednesday",
        time: "17:00 - 18:00",
        placeID: placeID_parkyBlinders,
        participantIDs: [folkID_tom, folkID_carlos, folkID_david, folkID_aisha],
        photos: [
            EventPhoto(icon: "figure.boxing", colors: [Color(hex: 0xEF5350), Color(hex: 0xC62828)], caption: "Boxing drills"),
            EventPhoto(icon: "heart.fill", colors: [Color(hex: 0xE57373), Color(hex: 0xD32F2F)], caption: "Team spirit"),
            EventPhoto(icon: "flame.fill", colors: [Color(hex: 0xFF7043), Color(hex: 0xE64A19)], caption: "High energy session"),
        ]
    ),
    PlaceActivity(
        id: actID_thursdayPower,
        name: "Strength & Conditioning",
        description: "Build strength, improve balance, and maintain daily function. All abilities welcome in a supportive group environment. Trainers adjust every exercise to your level.",
        date: date(2026, 4, 2, hour: 12, minute: 0),
        recurrence: "Weekly every Thursday",
        time: "12:00 - 13:00",
        placeID: placeID_powerUpParkies,
        participantIDs: [folkID_george, folkID_helen, folkID_mike, folkID_margaret],
        photos: [
            EventPhoto(icon: "dumbbell.fill", colors: [Color(hex: 0x7E57C2), Color(hex: 0x4527A0)], caption: "Strength training"),
            EventPhoto(icon: "figure.strengthtraining.traditional", colors: [Color(hex: 0x9575CD), Color(hex: 0x5E35B1)], caption: "All levels welcome"),
        ]
    ),
    PlaceActivity(
        id: actID_fridayGym,
        name: "Friday Gym Session",
        description: "Tailored gym exercises for all ability levels. Led by instructors trained in neurological conditions. Bring comfortable clothing and water. Cafe on site for post-workout chat.",
        date: date(2026, 4, 3, hour: 13, minute: 30),
        recurrence: "Weekly every Friday",
        time: "13:30 - 14:30",
        placeID: placeID_exerciseGroup,
        participantIDs: [folkID_margaret, folkID_david, folkID_tom, folkID_janet],
        photos: [
            EventPhoto(icon: "figure.run", colors: [Color(hex: 0x42A5F5), Color(hex: 0x1565C0)], caption: "Group exercises"),
            EventPhoto(icon: "heart.circle.fill", colors: [Color(hex: 0x64B5F6), Color(hex: 0x1976D2)], caption: "Stay active together"),
        ]
    ),
    PlaceActivity(
        id: actID_saturdayCoffee,
        name: "Saturday Coffee Morning",
        description: "A relaxed coffee morning for anyone in the community. No agenda, no pressure \u{2014} just good coffee and people who get it. First-timers especially welcome. Hosted by Priya.",
        date: date(2026, 4, 4, hour: 10, minute: 0),
        recurrence: "Weekly every Saturday",
        time: "10:00 - 11:30",
        placeID: placeID_wandsworthCafe,
        participantIDs: [folkID_priya, folkID_janet, folkID_helen, folkID_margaret, folkID_aisha],
        photos: [
            EventPhoto(icon: "cup.and.saucer.fill", colors: [Color(hex: 0xFFCC80), Color(hex: 0xE65100)], caption: "Coffee and chat"),
            EventPhoto(icon: "person.3.fill", colors: [Color(hex: 0xFFE0B2), Color(hex: 0xEF6C00)], caption: "Community gathering"),
            EventPhoto(icon: "face.smiling.fill", colors: [Color(hex: 0xFFB74D), Color(hex: 0xF57C00)], caption: "Good company"),
        ],
        stageFilter: nil
    ),
    PlaceActivity(
        id: actID_sundayWalk,
        name: "Sunday Park Walk",
        description: "A gentle walk through the park with a coffee stop halfway. Benches every 100m if you need a rest. Dogs welcome. We go at the slowest person's pace \u{2014} no rush.",
        date: date(2026, 4, 5, hour: 10, minute: 30),
        recurrence: "Weekly every Sunday",
        time: "10:30 - 12:00",
        placeID: placeID_wandsworthCafe,
        participantIDs: [folkID_tom, folkID_helen, folkID_george],
        photos: [
            EventPhoto(icon: "figure.walk", colors: [Color(hex: 0x81C784), Color(hex: 0x2E7D32)], caption: "Walking together"),
            EventPhoto(icon: "tree.fill", colors: [Color(hex: 0xA5D6A7), Color(hex: 0x388E3C)], caption: "Beautiful park routes"),
        ],
        stageFilter: .early
    ),

    // MARK: Week of 6 Apr (next week)
    PlaceActivity(
        id: actID_mondayFootball2,
        name: "Walking Football Match",
        description: "Adapted football on a 3G pitch. Coached by Chelsea FC Foundation staff. All abilities welcome, no experience needed.",
        date: date(2026, 4, 6, hour: 10, minute: 30),
        recurrence: "Weekly every Monday",
        time: "10:30 - 11:30",
        placeID: placeID_walkingFootball,
        participantIDs: [folkID_george, folkID_carlos, folkID_tom, folkID_mike],
        photos: [
            EventPhoto(icon: "soccerball", colors: [Color(hex: 0x4CAF50), Color(hex: 0x2E7D32)], caption: "Match day"),
        ]
    ),
    PlaceActivity(
        id: actID_camdenSocial,
        name: "Camden Monthly Social",
        description: "Informal evening get-together for working-age people with invisible challenges and their carers. No agenda, just good conversation. Drinks and snacks available to purchase.",
        date: date(2026, 4, 8, hour: 18, minute: 0),
        recurrence: "Monthly",
        time: "18:00 onwards",
        placeID: placeID_camdenMeetup,
        participantIDs: [folkID_aisha, folkID_priya, folkID_helen, folkID_david, folkID_carlos],
        photos: [
            EventPhoto(icon: "person.3.fill", colors: [Color(hex: 0xFFB74D), Color(hex: 0xE65100)], caption: "Monthly gathering"),
            EventPhoto(icon: "music.note", colors: [Color(hex: 0xFFCC80), Color(hex: 0xEF6C00)], caption: "Live music night"),
        ]
    ),
    PlaceActivity(
        id: actID_wedBoxing2,
        name: "Non-Contact Boxing Class",
        description: "Fun, supportive boxing for all mobility levels. Improves balance, coordination, agility, and mental sharpness.",
        date: date(2026, 4, 8, hour: 17, minute: 0),
        recurrence: "Weekly every Wednesday",
        time: "17:00 - 18:00",
        placeID: placeID_parkyBlinders,
        participantIDs: [folkID_tom, folkID_carlos, folkID_david, folkID_aisha],
        photos: [
            EventPhoto(icon: "figure.boxing", colors: [Color(hex: 0xEF5350), Color(hex: 0xC62828)], caption: "Boxing class"),
        ]
    ),
    PlaceActivity(
        id: actID_thursdayPower2,
        name: "Strength & Conditioning",
        description: "Build strength, improve balance, and maintain daily function. Special focus on upper body this week.",
        date: date(2026, 4, 9, hour: 12, minute: 0),
        recurrence: "Weekly every Thursday",
        time: "12:00 - 13:00",
        placeID: placeID_powerUpParkies,
        participantIDs: [folkID_george, folkID_helen, folkID_mike, folkID_margaret],
        photos: [
            EventPhoto(icon: "dumbbell.fill", colors: [Color(hex: 0x7E57C2), Color(hex: 0x4527A0)], caption: "Upper body focus"),
        ]
    ),
    PlaceActivity(
        id: actID_balanceWorkshop,
        name: "Balance & Falls Prevention",
        description: "Special workshop focusing on balance exercises and falls prevention techniques. Open to all members. Physiotherapist-led session with take-home exercises.",
        date: date(2026, 4, 10, hour: 13, minute: 30),
        recurrence: nil,
        time: "13:30 - 15:00",
        placeID: placeID_exerciseGroup,
        participantIDs: [folkID_margaret, folkID_janet, folkID_tom],
        photos: [
            EventPhoto(icon: "figure.stand", colors: [Color(hex: 0x26C6DA), Color(hex: 0x00838F)], caption: "Balance exercises"),
            EventPhoto(icon: "hand.raised.fill", colors: [Color(hex: 0x4DD0E1), Color(hex: 0x00ACC1)], caption: "Expert guidance"),
        ]
    ),
    PlaceActivity(
        id: actID_fridayGym2,
        name: "Friday Gym Session",
        description: "Tailored gym exercises for all ability levels. Led by instructors trained in neurological conditions.",
        date: date(2026, 4, 10, hour: 13, minute: 30),
        recurrence: "Weekly every Friday",
        time: "13:30 - 14:30",
        placeID: placeID_exerciseGroup,
        participantIDs: [folkID_margaret, folkID_david, folkID_tom, folkID_janet],
        photos: [
            EventPhoto(icon: "figure.run", colors: [Color(hex: 0x42A5F5), Color(hex: 0x1565C0)], caption: "Friday workout"),
        ]
    ),

    // MARK: Week of 13 Apr
    PlaceActivity(
        id: actID_newMembersWelcome,
        name: "New Members Welcome Evening",
        description: "A special evening to welcome anyone recently diagnosed or new to the community. Hear from existing members and ask questions in a safe space. Light refreshments provided.",
        date: date(2026, 4, 15, hour: 18, minute: 0),
        recurrence: nil,
        time: "18:00 - 19:30",
        placeID: placeID_camdenMeetup,
        participantIDs: [folkID_aisha, folkID_priya, folkID_helen],
        photos: [
            EventPhoto(icon: "hand.wave.fill", colors: [Color(hex: 0xF48FB1), Color(hex: 0xC2185B)], caption: "Welcome evening"),
            EventPhoto(icon: "heart.fill", colors: [Color(hex: 0xF06292), Color(hex: 0xAD1457)], caption: "Safe space"),
        ]
    ),
    PlaceActivity(
        id: actID_artWorkshop,
        name: "Art & Chat Workshop",
        description: "Drop-in art session. Painting, drawing, collage \u{2014} whatever you feel like. Materials provided. No talent required, just company. Led by local artist and community member Priya.",
        date: date(2026, 4, 16, hour: 14, minute: 0),
        recurrence: nil,
        time: "14:00 - 16:00",
        placeID: placeID_camdenMeetup,
        participantIDs: [folkID_priya, folkID_margaret, folkID_helen, folkID_aisha, folkID_janet],
        photos: [
            EventPhoto(icon: "paintpalette.fill", colors: [Color(hex: 0xFFCC80), Color(hex: 0xE65100)], caption: "Creative afternoon"),
            EventPhoto(icon: "paintbrush.fill", colors: [Color(hex: 0xFFE0B2), Color(hex: 0xEF6C00)], caption: "All materials provided"),
            EventPhoto(icon: "photo.artframe", colors: [Color(hex: 0xFFB74D), Color(hex: 0xF57C00)], caption: "Display your art"),
        ]
    ),

    // MARK: Week of 20 Apr
    PlaceActivity(
        id: actID_cafeCatchUp,
        name: "Cafe Catch-Up",
        description: "Relaxed social over tea and cake at the beautiful Battersea Arts Centre. Everyone welcome including family and friends. A chance to connect and share stories.",
        date: date(2026, 4, 20, hour: 11, minute: 0),
        recurrence: "Monthly on the 3rd Monday",
        time: "11:00 - 12:30",
        placeID: placeID_wandsworthCafe,
        participantIDs: [folkID_janet, folkID_priya, folkID_margaret, folkID_helen, folkID_aisha],
        photos: [
            EventPhoto(icon: "cup.and.saucer.fill", colors: [Color(hex: 0xBCAAA4), Color(hex: 0x5D4037)], caption: "Tea and cake"),
            EventPhoto(icon: "building.columns.fill", colors: [Color(hex: 0xD7CCC8), Color(hex: 0x6D4C41)], caption: "Battersea Arts Centre"),
        ]
    ),
    PlaceActivity(
        id: actID_gardenParty,
        name: "Spring Garden Party",
        description: "Celebrate spring with the community! Outdoor gathering in the Battersea Arts Centre garden. Bring a dish to share if you can. Live music from Carlos on guitar.",
        date: date(2026, 4, 25, hour: 13, minute: 0),
        recurrence: nil,
        time: "13:00 - 16:00",
        placeID: placeID_wandsworthCafe,
        participantIDs: [folkID_carlos, folkID_priya, folkID_margaret, folkID_helen, folkID_aisha, folkID_tom, folkID_janet, folkID_george],
        photos: [
            EventPhoto(icon: "leaf.fill", colors: [Color(hex: 0x81C784), Color(hex: 0x2E7D32)], caption: "Garden celebration"),
            EventPhoto(icon: "music.note.list", colors: [Color(hex: 0xA5D6A7), Color(hex: 0x388E3C)], caption: "Live music"),
            EventPhoto(icon: "birthday.cake.fill", colors: [Color(hex: 0xFFCC80), Color(hex: 0xEF6C00)], caption: "Food and fun"),
            EventPhoto(icon: "sun.max.fill", colors: [Color(hex: 0xFFF176), Color(hex: 0xF9A825)], caption: "Spring sunshine"),
        ]
    ),
    PlaceActivity(
        id: actID_musicSession,
        name: "Music & Movement",
        description: "A joyful session combining music therapy with gentle movement. Singing, rhythm exercises, and light dance \u{2014} proven to help with speech and coordination. All welcome.",
        date: date(2026, 4, 22, hour: 15, minute: 0),
        recurrence: nil,
        time: "15:00 - 16:30",
        placeID: placeID_camdenMeetup,
        participantIDs: [folkID_helen, folkID_margaret, folkID_carlos, folkID_priya],
        photos: [
            EventPhoto(icon: "music.note", colors: [Color(hex: 0xCE93D8), Color(hex: 0x8E24AA)], caption: "Music therapy"),
            EventPhoto(icon: "figure.dance", colors: [Color(hex: 0xBA68C8), Color(hex: 0x7B1FA2)], caption: "Gentle movement"),
        ]
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

func discoverableNearbyCount() -> Int { sampleFolk.filter { $0.isDiscoverable }.count }

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
    interests: [.photography, .walking, .technology],
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

// MARK: - Notifications

let sampleNotifications: [NotificationItem] = [
    NotificationItem(title: "New event near you", message: "Walking Football at Chelsea FC Foundation just posted a new session for Monday at 10:30.", icon: "calendar.badge.plus", tint: Theme.green, date: Date().addingTimeInterval(-3600)),
    NotificationItem(title: "Margaret started following you", message: "Margaret H. from the Adaptive Exercise Group is now following your journey.", icon: "person.badge.plus", tint: Theme.accent, date: Date().addingTimeInterval(-7200)),
    NotificationItem(title: "Community Hub verified", message: "Wandsworth Community Cafe has been verified by the community. Staff training completed!", icon: "checkmark.seal.fill", tint: Theme.cyan, date: Date().addingTimeInterval(-86400)),
    NotificationItem(title: "New friendly space added", message: "Costa Coffee at King's Cross has been added as a tulip-certified space by a community member.", icon: "mappin.circle.fill", tint: Theme.orange, date: Date().addingTimeInterval(-172800)),
    NotificationItem(title: "Milestone unlocked!", message: "You've been part of the Stigma community for 7 days. Keep going — you're building connections!", icon: "star.fill", tint: .yellow, date: Date().addingTimeInterval(-259200)),
]
