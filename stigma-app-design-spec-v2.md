# Stigma App — Design Spec v2

## Visual System
- Background: `#FAF5EB` (cream)
- Card bg: `#F0E8D8` (warm sand)
- Primary text: `#5C4A1E` (dark brown)
- Secondary text: `#9C8A5E` (muted brown)
- Accent pink: `#E8A0B4` (tulip pink)
- Accent green: `#A8D84E` (going/RSVP)
- Accent coral: `#E88B6E` (alerts)
- Card radius: 16pt
- Button radius: 12pt
- Image radius: 12pt (in-feed), 0pt (full-bleed headers)
- Font: SF Pro (system). Titles 20pt semibold, body 15pt regular, captions 13pt regular muted.
- Spacing: 16pt between cards, 12pt internal padding, 20pt horizontal margins.

---

## Tab Bar
```
[ Home/Feed ]  [ Explore Map ]  [ Calendar ]  [ Profile ]
```
- Icons: line style, brown `#5C4A1E` inactive, pink `#E8A0B4` active with filled variant.
- Labels below icons, 10pt.

---

## Screen 1: HOME / FEED

The main screen. A vertical scrolling feed combining community updates, upcoming events, nearby venues, and gentle nudges. Feels like Strava's activity feed but warmer and without performance pressure.

### Top section (sticky):
- Greeting: "Good morning, [Name]" left-aligned, 20pt semibold.
- Right side: notification bell icon + small Charm battery indicator (if connected).
- Below: horizontal date strip showing the current week (Mon–Sun), today highlighted in pink circle. Tapping a day filters feed to show that day's events. This is the calendar preview.

### Feed cards (vertical scroll, mixed types):

**Type A — Event Card**
```
┌─────────────────────────────────┐
│ [Image — full width, 180pt]     │
│                                 │
├─────────────────────────────────┤
│ Coffee at The Greenhouse        │  ← 17pt semibold
│ Saturday 5 Apr · 10:00 – 11:30  │  ← 13pt muted
│ The Greenhouse, Brixton         │  ← 13pt muted + tulip icon
│                                 │
│ 🌷 4 going · All stages         │  ← 13pt, green dot before "4"
│                                 │
│ ┌───────────┐  ┌─────────────┐  │
│ │  I'm going │  │  Not for me │  │  ← green fill / outline
│ └───────────┘  └─────────────┘  │
└─────────────────────────────────┘
```
- Image: event photo or venue photo. For demo, use placeholder images (see assets section below).
- "I'm going" button: green `#A8D84E` bg, white text. Tapping changes to checkmark + "You're going!" and adds to calendar.
- "Not for me" button: outline only, muted text. Tapping hides the card gently (no guilt — just slides away).
- Tapping the card itself (not buttons) opens the Event Detail page.

**Type B — Venue Spotlight Card**
```
┌─────────────────────────────────┐
│ [Image — full width, 140pt]     │
├─────────────────────────────────┤
│ 🌷 New tulip space near you     │  ← 13pt pink, label
│ Rock Steady Boxing Brixton      │  ← 17pt semibold
│ 0.4 mi · Gym · ★ 4.9           │  ← 13pt muted
│ Step-free · PD classes · Quiet  │  ← pills/tags
│                                 │
│        [ Check it out → ]       │  ← text button
└─────────────────────────────────┘
```
- Appears when user is near a venue they haven't visited, or when a new venue joins.
- "Check it out" opens venue detail.

**Type C — Community Update Card**
```
┌─────────────────────────────────┐
│ 🌷 This week in your community  │  ← 13pt pink label
│                                 │
│ 12 members active nearby        │
│ 3 events happening              │
│ 1 new tulip space certified     │
│                                 │
│ "47 people in London carried    │
│  their Charm this week"         │  ← italics, warm
└─────────────────────────────────┘
```
- Weekly summary card. Appears once a week, Monday morning.
- No individual names. All anonymised stats.
- Tone is warm, factual, inviting. Never "you missed 3 events" (no FOMO).

**Type D — Gentle Nudge Card**
```
┌─────────────────────────────────┐
│ You visited The Greenhouse last  │
│ week. There's a coffee morning   │
│ there this Saturday.             │
│                                 │
│       [ See the event → ]       │
└─────────────────────────────────┘
```
- Context-aware nudge based on past visits or check-ins.
- Only appears if user has visited a venue before. Never cold. Never pushy.
- Max 1 nudge card per day in the feed.

**Type E — Weekly Check-in Card (appears once per week)**
```
┌─────────────────────────────────┐
│ Weekly reflection                │  ← 15pt semibold
│                                 │
│ How was your week?               │
│                                 │
│  😫  😕  😐  🙂  😊            │  ← 5 tappable faces
│                                 │
│ "How confident did you feel      │
│  going out this week?"           │
│                                 │
│  ○───────────●──────○           │  ← slider, low to high
│  Not at all       Very          │
│                                 │
│       [ Submit ]  [ Skip ]      │
└─────────────────────────────────┘
```
- Inline in feed, not a popup or modal. User can scroll past it.
- After submitting, card transforms to "Thanks. Here's to next week 🌷"
- Data feeds into journey tracking and subtle stage refinement.

### Feed ordering:
1. Weekly check-in (if due, pinned to top)
2. Events happening today or tomorrow
3. Gentle nudge (if any, max 1)
4. Upcoming events this week (sorted by date)
5. Venue spotlight (if new venue or unvisited nearby)
6. Community update (if weekly summary due)

### Anti-FOMO principles:
- Never show "You missed this event" or "5 people went without you."
- Past events disappear from feed silently.
- Language is always invitational: "happening Saturday" not "don't miss."
- No streak counters, no activity scores, no comparisons to others.
- The feed should feel like a community noticeboard in a friendly café, not a social media timeline.

---

## Screen 2: EXPLORE MAP

### Layout:
- MapKit fills screen.
- Custom tulip pin annotations for venues. Pink tulip icon, slightly larger than default pins.
- Blue dot for user location.
- Search bar overlaid at top: "Search tulip spaces..."
- Filter chips below search: `All` `Café` `Gym` `Park` `Community` — horizontally scrollable, pill-shaped, outline when inactive, filled pink when active.

### Bottom sheet (draggable, half-height default):
- List of nearby venues sorted by distance.
- Each row:
  ```
  [Venue photo thumb 48x48] | Name (semibold)        | 0.3 mi
                             | Type · Rating ★ 4.6    |
                             | Step-free, Quiet        |
  ```
- Tapping a row opens Venue Detail.
- Tapping a pin on map opens bottom sheet scrolled to that venue.

### Venue Detail Page:
```
┌─────────────────────────────────┐
│ [Hero image — full bleed, 220pt]│
├─────────────────────────────────┤
│ The Greenhouse            🌷    │  ← name + tulip badge
│ Café · Brixton · 0.3 mi        │
│ ★ 4.6 · Open now                │
│                                 │
│ ┌─────┐ ┌──────┐ ┌───────────┐ │
│ │Step-│ │Quiet │ │Patient    │ │  ← accessibility pills
│ │free │ │      │ │staff      │ │
│ └─────┘ └──────┘ └───────────┘ │
│                                 │
│ About                           │
│ "A calm, welcoming café with    │
│ PD-aware staff. Smooth floors,  │
│ plenty of seating, no rush."    │
│                                 │
│ Community notes                 │
│ "Great corner table by the      │
│ window — quiet and private"     │
│ — Community member              │
│                                 │
│ Photos                          │
│ [ img ] [ img ] [ img ]         │  ← horizontal scroll gallery
│                                 │
│ Upcoming events here            │
│ ┌─ Coffee Morning ────── Sat ─┐ │
│ │ 4 going · All stages        │ │
│ │        [ I'm going ]        │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌──────────┐ ┌────────────────┐ │
│ │ Check in │ │ Get directions │ │
│ └──────────┘ └────────────────┘ │
└─────────────────────────────────┘
```
- "Check in" simulates NFC tap for demo. Shows confetti and "Welcome to The Greenhouse 🌷".
- "Get directions" opens Apple Maps.
- Photo gallery: horizontal scroll of 3-5 images. For demo, use placeholders.

---

## Screen 3: CALENDAR

A dedicated calendar view showing your RSVPed events and check-ins.

### Layout:
- Month view at top (compact, like iOS calendar). Days with events have a pink dot below the number.
- Tapping a day shows that day's events below.
- Below calendar: list of upcoming RSVPed events (chronological).

### Event row in calendar:
```
┌─────────────────────────────────┐
│ 10:00  Coffee at The Greenhouse │
│        The Greenhouse, Brixton  │
│        4 going · You're going ✓ │
│                                 │
│  [ Remove from calendar ]       │  ← subtle text button
└─────────────────────────────────┘
```

### Empty state (no events):
```
"Your calendar is clear this week.
Browse events to find something you'd enjoy."

         [ Explore events → ]
```
- Tone: neutral, not guilt-inducing. "Clear" not "empty."

---

## Screen 4: PROFILE

### Layout:
```
┌─────────────────────────────────┐
│      [ Initials circle ]        │  ← 64pt, pink bg, brown text
│         [Name]                  │  ← 20pt semibold
│    Diagnosed [year] · [Stage]   │  ← 13pt muted
│        [ Edit profile ]         │  ← text button
├─────────────────────────────────┤
│ My journey                      │
│ ● First carry                   │  ← achieved, coloured
│ ● First tulip visit             │  ← achieved
│ ○ First event                   │  ← not yet, greyed
│ ○ First hello                   │  ← not yet
│ ○ First event created           │  ← not yet
│                                 │
│ [See all milestones →]          │
├─────────────────────────────────┤
│ My symptoms                     │
│ "Help us find the right spaces  │
│  and people for you"            │
│                                 │
│ [Add symptoms →]                │  ← only shows if not yet filled
│  or                             │
│ Tremor · Fatigue · Anxiety      │  ← pills showing current
│ [Edit →]                        │
├─────────────────────────────────┤
│ Charm                           │
│ Connected ✓  Battery: 72%       │
│ Companion: [Partner name]       │
│ Signal meanings:                │
│  Quick squeeze → "I'm okay"    │
│  Long squeeze → "Come find me"  │
│ [Edit Charm settings →]         │
├─────────────────────────────────┤
│ My interests                    │
│ Walking · Boxing · Coffee       │
│ [Edit →]                        │
├─────────────────────────────────┤
│ Settings                        │
│ Notifications                   │
│ Privacy (Discoverable: On)      │
│ About Stigma                    │
│ Sign out                        │
└─────────────────────────────────┘
```

---

## Symptom Collection — Progressive Disclosure Approach

Symptoms are NEVER required. They are introduced gradually through the app experience.

### Trigger 1: After first venue visit
The app shows an inline card in the feed:
```
"You visited The Greenhouse! Want us to recommend
places based on what matters to you?"

   [ Yes, personalise ] [ Not yet ]
```
Tapping "Yes" opens a quick 2-question flow:
- "What do you notice most when you're out?" (the 5 tappable cards from onboarding)
- "One side or both?"
That's it. Takes 20 seconds. Now venue recommendations are personalised.

### Trigger 2: After third event RSVP
```
"You're getting active! Adding a few details helps us
match you with people at a similar stage."

   [ Sure ] [ Skip ]
```
Opens the interests picker if not already done, plus the diagnosis timeframe.

### Trigger 3: Available anytime in Profile
The "My symptoms" section in Profile lets users optionally add the full detail:

**Category: Movement**
- Tremor: off / mild / moderate / significant
- Freezing: off / mild / moderate / significant
- Instability / Falls: off / mild / moderate / significant
- Slowness of movement: off / mild / moderate / significant

**Category: Communication**
- Quiet or slow speech: off / mild / moderate / significant
- Facial masking: off / mild / moderate / significant
- Small handwriting: off / on

**Category: Energy & Comfort**
- Fatigue: off / mild / moderate / significant
- Pain: off / mild / moderate / significant
- Muscle cramps: off / mild / moderate / significant
- Dizziness: off / mild / moderate / significant

**Category: Mood**
- Anxiety: off / mild / moderate / significant
- Depression: off / mild / moderate / significant

**Category: Daily Living**
- Difficulty swallowing: off / mild / moderate / significant
- Drooling: off / mild / moderate / significant
- Daytime sleepiness: off / mild / moderate / significant
- Insomnia: off / mild / moderate / significant

**Free text:** "Anything else you'd like us to know?"

### Symptom UI:
Each symptom row is a single horizontal line:
```
Tremor              [off] [mild] [mod] [sig]
```
Segmented control style. Default is "off". Tapping any level highlights it in pink. The whole category collapses by default — tap the category header to expand. This means someone can add just "Tremor: moderate" in 2 taps without seeing the other 17 items.

### What symptoms unlock (show the user):
- After adding movement symptoms: "Venues with smooth flooring and seating are now highlighted for you."
- After adding communication symptoms: "Events with smaller groups are now prioritised."
- After adding mood symptoms: "We'll suggest events at times when you usually feel your best."

---

## Event Detail Page

Tapping any event card in the feed or calendar opens this:

```
┌─────────────────────────────────┐
│ [Hero image — full bleed, 240pt]│
│                                 │
│  ┌──────────────────────────┐   │
│  │      I'm going! 🌷       │   │  ← floating RSVP button
│  └──────────────────────────┘   │  ← green, sticky at top
├─────────────────────────────────┤
│ Coffee at The Greenhouse        │  ← 22pt semibold
│                                 │
│ 📅 Saturday 5 April · 10–11:30  │
│ 📍 The Greenhouse, Brixton      │  ← tappable, opens venue
│ 🌷 All stages welcome           │
│ 👥 4 going                      │
│                                 │
│ About this event                │
│ "A relaxed coffee morning for   │
│ anyone in the community. No     │
│ agenda, no pressure — just good │
│ coffee and people who get it.   │
│ First-timers especially welcome.│
│ Hosted by Sarah."               │
│                                 │
│ Who's going                     │
│ [ S. ] [ J. ] [ M. ] [ +1 ]    │  ← initials circles
│ "People at a similar stage"     │  ← reassurance text
│                                 │
│ Photos                          │
│ [ img ] [ img ] [ img ]         │  ← gallery from past editions
│                                 │
│ Location                        │
│ [Mini MapKit view, 140pt]       │
│ [ Get directions ]              │
│                                 │
│ ┌──────────────────────────┐    │
│ │   Add to calendar 📅     │    │  ← adds to iOS calendar too
│ └──────────────────────────┘    │
│                                 │
│ ┌──────────────────────────┐    │
│ │   Share with companion   │    │
│ └──────────────────────────┘    │
└─────────────────────────────────┘
```

### RSVP states:
- Default: "I'm going!" (green button, white text)
- After tap: button changes to "You're going ✓" (lighter green, checkmark). Confetti animation.
- Event added to Calendar tab and optionally to iOS Calendar via EventKit.
- "Change your mind?" small text link below to un-RSVP (no judgement).

---

## Image Assets Strategy for Xcode

### For the demo/prototype:

**Option A (recommended): Use SF Symbols + coloured shapes.**
For venue and event cards where you don't have real photos, use a coloured rectangle with an SF Symbol icon centred:
```swift
ZStack {
    Rectangle()
        .fill(Color.stigmaCardBg)
        .frame(height: 180)
    Image(systemName: "cup.and.saucer.fill")
        .font(.system(size: 48))
        .foregroundColor(.stigmaBrown.opacity(0.3))
}
```
This looks intentional and designed, not broken. Use different icons per venue type: `cup.and.saucer.fill` for cafés, `figure.boxing` for gyms, `leaf.fill` for parks, `building.2.fill` for community centres.

**Option B: Add real photos to asset catalogue.**
If team members photograph actual London cafés, parks, or gyms, add them to `Assets.xcassets` as image sets. Name them consistently: `venue_greenhouse`, `venue_rocksteady`, `event_coffee_morning`. Use `.resizable().aspectRatio(contentMode: .fill)` with a `.frame(height: 180).clipped()`.

**Option C: Gradient placeholders.**
Warm gradient fills (cream to soft pink) with white text overlay showing the venue or event name. Looks polished and intentional:
```swift
LinearGradient(
    colors: [.stigmaCream, .stigmaPink.opacity(0.3)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
.frame(height: 180)
.overlay(
    Text("The Greenhouse")
        .font(.title3.weight(.semibold))
        .foregroundColor(.white)
        .shadow(radius: 2),
    alignment: .bottomLeading
)
```

### Gallery implementation:
For venue and event photo galleries, use a horizontal `ScrollView` with `LazyHStack`:
```swift
ScrollView(.horizontal, showsIndicators: false) {
    LazyHStack(spacing: 8) {
        ForEach(venue.photos, id: \.self) { photo in
            Image(photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    .padding(.horizontal, 20)
}
```

---

## SwiftUI View Hierarchy (updated)

```
StigmaApp
├── OnboardingCarousel (screens 1-6: intro, swipeable)
├── ProfileSetup (screens 7-12: name, journey, symptoms light, interests)
├── MainTabView
│   ├── Tab 1: FeedView (Home)
│   │   ├── WeekStrip (sticky top, date selector)
│   │   ├── FeedCard (protocol — all cards conform)
│   │   │   ├── EventFeedCard
│   │   │   ├── VenueSpotlightCard
│   │   │   ├── CommunityUpdateCard
│   │   │   ├── GentleNudgeCard
│   │   │   └── WeeklyCheckInCard
│   │   └── EventDetailView (push on tap)
│   │       ├── RSVPButton
│   │       ├── AttendeeAvatars
│   │       ├── PhotoGallery
│   │       └── MiniMapView
│   ├── Tab 2: ExploreMapView
│   │   ├── TulipMapView (MapKit)
│   │   ├── SearchBar
│   │   ├── FilterChips
│   │   ├── VenueListSheet (bottom sheet)
│   │   └── VenueDetailView (push on tap)
│   │       ├── PhotoGallery
│   │       ├── AccessibilityPills
│   │       ├── CommunityNotes
│   │       ├── UpcomingEventsHere
│   │       └── CheckInButton
│   ├── Tab 3: CalendarView
│   │   ├── MonthGrid (compact)
│   │   ├── DayEventsList
│   │   └── EmptyState
│   └── Tab 4: ProfileView
│       ├── ProfileHeader
│       ├── JourneyMilestones
│       ├── SymptomsSection (progressive)
│       ├── CharmSettings
│       ├── InterestsPills
│       └── SettingsList
└── Overlays
    ├── MatchmakingOverlay
    ├── CheckInCelebration
    └── RSVPConfirmation
```

---

## Sample Data (hardcoded for demo)

### Events:
```swift
let sampleEvents: [TulipEvent] = [
    TulipEvent(
        name: "Coffee at The Greenhouse",
        venue: "The Greenhouse",
        date: Date().next(.saturday).at(hour: 10),
        description: "A relaxed coffee morning for anyone in the community. No agenda, no pressure — just good coffee and people who get it. First-timers especially welcome.",
        attendeeCount: 4,
        stageFilter: nil, // all stages
        photos: ["event_coffee_1", "event_coffee_2"]
    ),
    TulipEvent(
        name: "PD Boxing — Beginners",
        venue: "Rock Steady Boxing Brixton",
        date: Date().next(.thursday).at(hour: 18),
        description: "Non-contact boxing class designed for people with Parkinson's. All fitness levels. Gloves provided. Come as you are.",
        attendeeCount: 8,
        stageFilter: nil,
        photos: ["event_boxing_1"]
    ),
    TulipEvent(
        name: "Park Walk — Slow Pace",
        venue: "Brockwell Park",
        date: Date().next(.tuesday).at(hour: 10, minute: 30),
        description: "A gentle walk through the park with a coffee stop halfway. Benches every 100m if you need a rest. Dogs welcome.",
        attendeeCount: 3,
        stageFilter: .early,
        photos: ["event_park_1", "event_park_2"]
    ),
    TulipEvent(
        name: "Art & Chat",
        venue: "Tulip Studio Peckham",
        date: Date().next(.wednesday).at(hour: 14),
        description: "Drop-in art session. Painting, drawing, collage — whatever you feel like. Materials provided. No talent required, just company.",
        attendeeCount: 5,
        stageFilter: nil,
        photos: ["event_art_1"]
    ),
    TulipEvent(
        name: "Yoga for Movement",
        venue: "The Movement Space",
        date: Date().next(.friday).at(hour: 11),
        description: "Gentle yoga adapted for Parkinson's. Focus on balance, flexibility, and breathing. Chair options available throughout.",
        attendeeCount: 6,
        stageFilter: nil,
        photos: ["event_yoga_1"]
    ),
    TulipEvent(
        name: "Saturday Social Lunch",
        venue: "The Greenhouse",
        date: Date().next(.saturday).at(hour: 12, minute: 30),
        description: "Lunch together after the morning coffee. Staff know us and the menu has large-print options. Separate bills, no fuss.",
        attendeeCount: 4,
        stageFilter: nil,
        photos: ["event_lunch_1"]
    ),
]
```

### Venues:
```swift
let sampleVenues: [TulipVenue] = [
    TulipVenue(
        name: "The Greenhouse",
        type: .cafe,
        latitude: 51.4613, longitude: -0.1156,
        rating: 4.6,
        accessibility: ["Step-free", "Quiet", "Patient staff", "Large-print menu"],
        communityNotes: ["Great corner table by the window", "Staff always remember your order"],
        photos: ["venue_greenhouse_1", "venue_greenhouse_2", "venue_greenhouse_3"]
    ),
    TulipVenue(
        name: "Rock Steady Boxing Brixton",
        type: .gym,
        latitude: 51.4577, longitude: -0.1159,
        rating: 4.9,
        accessibility: ["Step-free", "PD-specific classes", "Changing room benches"],
        communityNotes: ["Thursday class is best for beginners", "Coach Dave is incredible"],
        photos: ["venue_boxing_1", "venue_boxing_2"]
    ),
    TulipVenue(
        name: "Brockwell Park",
        type: .park,
        latitude: 51.4500, longitude: -0.1063,
        rating: 4.3,
        accessibility: ["Smooth paths", "Benches every 100m", "Accessible toilets at café"],
        communityNotes: ["Tuesday walking group meets at the café entrance", "Avoid the steep hill near the lido"],
        photos: ["venue_park_1", "venue_park_2"]
    ),
    TulipVenue(
        name: "Tulip Studio Peckham",
        type: .community,
        latitude: 51.4741, longitude: -0.0693,
        rating: 4.7,
        accessibility: ["Step-free", "Lift available", "Quiet room", "Wide tables"],
        communityNotes: ["Wednesday afternoon is the calmest session"],
        photos: ["venue_studio_1"]
    ),
    TulipVenue(
        name: "The Movement Space",
        type: .gym,
        latitude: 51.4655, longitude: -0.0845,
        rating: 4.5,
        accessibility: ["Step-free", "Sprung floor", "Chair yoga available"],
        communityNotes: ["Friday yoga is lovely", "Bring your own mat or borrow one"],
        photos: ["venue_movement_1"]
    ),
    TulipVenue(
        name: "Lordship Lane Café",
        type: .cafe,
        latitude: 51.4560, longitude: -0.0747,
        rating: 4.2,
        accessibility: ["Step-free", "Quiet mornings", "Non-slip flooring"],
        communityNotes: ["Best before 11am when it's calm"],
        photos: ["venue_lordship_1"]
    ),
    TulipVenue(
        name: "Dulwich Park",
        type: .park,
        latitude: 51.4466, longitude: -0.0744,
        rating: 4.4,
        accessibility: ["Flat paths", "Benches throughout", "Accessible café"],
        communityNotes: ["The boating lake loop is the smoothest path"],
        photos: ["venue_dulwich_1"]
    ),
    TulipVenue(
        name: "Camberwell Library",
        type: .community,
        latitude: 51.4736, longitude: -0.0933,
        rating: 4.1,
        accessibility: ["Step-free", "Lift", "Quiet", "Hearing loop"],
        communityNotes: ["Reading group meets first Monday of the month"],
        photos: ["venue_library_1"]
    ),
]
```

---

## Build Priority (updated)

### Day 1 — Core screens:
- [ ] FeedView with EventFeedCard and RSVP button
- [ ] EventDetailView with hero image, description, RSVP, calendar add
- [ ] ExploreMapView with venue pins
- [ ] CalendarView with month grid and event list

### Day 2 — Polish and detail:
- [ ] VenueDetailView with gallery, accessibility pills, community notes
- [ ] ProfileView with journey milestones and symptom section
- [ ] Onboarding carousel (6 intro screens)
- [ ] Matchmaking overlay animation
- [ ] Weekly check-in card in feed
- [ ] RSVP confetti animation
- [ ] Check-in celebration animation
