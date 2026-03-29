# Parkinson’s Social App — Symptom Input UX Spec

## Goal

Implement symptom input in a way that supports:

- better people matching
- better venue/event recommendations
- optional profile personalization

without making the app feel like a medical intake form.

The product should feel like a **social confidence and connection app**, not a clinical tracker.

---

## Core Product Principle

Do **not** present symptoms as a long medical checklist during onboarding.

Why:

- it increases friction
- it makes the experience feel clinical
- it may make users feel labelled as patients rather than people joining a community
- it weakens the social and welcoming tone of the app

Instead:

- keep onboarding very short
- use plain, everyday language
- collect only the minimum useful information first
- allow more detailed symptom editing later in profile/settings

---

## Recommended Information Architecture

Use **two layers**:

1. **Onboarding layer** — fast, required, low-friction
2. **Profile layer** — optional, editable, more detailed

---

# 1. Onboarding Layer

## Target

Maximum: **3 screens**, around **30–60 seconds**

The onboarding should collect enough data to:

- estimate broad stage/context
- support matching with similar experiences
- personalize venue recommendations

## Screen 1 — Journey Stage

### Prompt
**Where are you on your journey?**

### Options
- Recently diagnosed (0–2 years)
- Living with it (2–10 years)
- Long-term (11+ years)

### Notes
- use friendly wording
- do not use clinical staging language here
- single choice only

---

## Screen 2 — Main Experiences When Out

### Prompt
**When you’re out and about, what do you notice most?**

### UI
Use **large multi-select cards**, not a long checklist.

### Recommended card set
- My hands shake
- I move slowly or freeze
- My voice is quiet / people misread my expression
- I get tired quickly
- I feel anxious in social situations

### Mapping behind the scenes
- My hands shake → tremor
- I move slowly or freeze → bradykinesia + freezing
- My voice is quiet / people misread my expression → hypophonia + facial masking
- I get tired quickly → fatigue
- I feel anxious in social situations → anxiety / depression-related social friction

### Notes
- use plain English
- avoid Latin/clinical terms in the main UI
- allow multi-select
- each card can have a simple icon or small body cue
- do not force severity sliders here

---

## Screen 3 — Body Distribution

### Prompt
**Does it mostly affect one side of your body, or both?**

### Options
- Mostly one side
- Both sides
- All over

### Notes
- single choice
- this gives useful stage/context data without clinical language
- much better than a detailed body drawing interaction for onboarding

---

# 2. Profile Layer (Optional)

## Purpose

A user can later add more detail in a profile/settings section.

Suggested section title:

**Help us find the right spaces and people for you**

This framing is better than “Symptoms” alone because it explains the value of sharing data.

## UX Rules

- fully optional
- editable any time
- categories first, details second
- toggles first, sliders only when needed
- should feel like preference setup, not medical form filling

---

## Recommended Symptom Categories

### A. Movement
Keep:
- Tremor
- Freezing
- Instability / balance issues
- Falls

Possible merge:
- Bradykinesia should not appear as a heavy clinical term in primary UI  
  It can be translated into something like:
  - Moving slowly
  - Difficulty getting started
  - Freezing / movement hesitation

### B. Communication
Keep:
- Quiet or slower speech
- Reduced facial expression

### C. Energy / Comfort
Keep:
- Fatigue
- Pain

### D. Mood / Social Confidence
Keep:
- Anxiety
- Depression

### E. Other
Keep:
- Free text field: “Anything else you’d like us to know?”

---

## Symptoms to Remove from Main Product Flow

These may be real and important, but they should **not** be central in onboarding for this social app:

- Micrographia
- Dysphagia
- Insomnia
- Muscle cramps
- Dizziness as a standalone onboarding item
- Drooling as a major onboarding item unless later testing shows strong usefulness

### Why remove or de-prioritize
These are less useful for:
- social matching
- venue recommendation
- low-friction onboarding

Some can still exist in optional detailed profile settings if needed later.

---

## Recommended Interaction Model

## Default input style
Use:

- **multi-select cards** in onboarding
- **toggles** in profile
- **expandable sections** for categories
- **optional severity only after selection**

## Severity input
Do **not** show sliders by default.

If a user selects a symptom, then optionally show:

- Mild
- Moderate
- Significant

This can be:

- segmented control
- three-step chip selector
- compact stepped slider

Avoid freeform continuous sliders unless there is a very strong reason.

---

## Body Map Idea — Recommendation

Do **not** use a detailed body drawing interaction as the primary symptom input.

### Why
- Parkinson’s symptoms do not always map neatly to body zones
- some symptoms are social or invisible rather than anatomical
- the interaction feels too clinical
- it risks resembling physio or pain-tracking intake

### Better alternative
Use:

- a simple **distribution question** (“one side / both / all over”)
- small supporting icons on symptom cards
- optional body-region detail later only for movement-related symptoms if really needed

---

## Additional Data Worth Adding

## 1. Best Time of Day / Medication Window
This is highly valuable.

### Prompt example
**When do you usually feel your best going out?**

### Options
- Morning
- Midday
- Afternoon
- Evening

Optional future version:
- Let users enter typical “on” periods after medication

### Why this matters
This can improve:
- event timing recommendations
- friend matching
- confidence planning for outings

This is likely more useful than several low-impact symptom fields.

---

## 2. Visible vs Invisible Difficulties
This distinction is useful for matching and social understanding.

### Prompt examples
**What do other people tend to notice?**
- Shaking
- Slowness / freezing
- Quiet speech
- Reduced facial expression
- Balance issues
- Prefer not to say

**What affects you most, even if others don’t notice it?**
- Fatigue
- Anxiety
- Pain
- Low mood
- Something else

### Why this matters
Two people may both have Parkinson’s but experience public life very differently.

This helps matching feel more meaningful.

---

# Final Recommended Data Model

## Minimum onboarding fields
- diagnosis_year_band
- primary_out_and_about_experiences[]  
- body_distribution
- best_time_of_day (recommended addition)

## Optional profile fields
- movement.tremor
- movement.freezing
- movement.instability
- movement.falls
- communication.quiet_speech
- communication.reduced_expression
- energy.fatigue
- energy.pain
- mood.anxiety
- mood.depression
- visible_symptoms[]
- invisible_challenges[]
- other_notes
- severity per selected item (optional)

---

# Suggested Onboarding Copy

## Screen 1
**Where are you on your journey?**  
- Recently diagnosed (0–2 years)  
- Living with it (2–10 years)  
- Long-term (11+ years)

## Screen 2
**When you’re out and about, what do you notice most?**  
- My hands shake  
- I move slowly or freeze  
- My voice is quiet / people misread my expression  
- I get tired quickly  
- I feel anxious in social situations

## Screen 3
**Does it mostly affect one side of your body, or both?**  
- Mostly one side  
- Both sides  
- All over

## Optional Screen 4 or Profile Prompt
**When do you usually feel your best going out?**  
- Morning  
- Midday  
- Afternoon  
- Evening

---

# What This Data Should Unlock

After onboarding, the app should immediately use the data.

## Venue recommendations
Examples:
- fatigue → places with seating
- freezing / instability → smooth flooring, step-free access
- quiet speech → quieter venues
- anxiety → calmer, less crowded spaces

## Matching
Match based on:
- similar lived experiences
- similar social challenges
- similar comfort patterns when going out

Do **not** match only by diagnosis label.

---

# Xcode Implementation Plan

## Step 1 — Create onboarding data model
Create a lightweight model for:
- journey stage
- selected experience cards
- body distribution
- best time of day

## Step 2 — Build onboarding UI
Implement:
- single-select screen for journey stage
- multi-select card screen for core experiences
- single-select screen for body distribution
- optional best-time screen

## Step 3 — Save to user profile
Store onboarding responses in the user profile object / backend model.

## Step 4 — Build profile editing screen
Create expandable categories:
- Movement
- Communication
- Energy / Comfort
- Mood
- Other

Each item:
- toggle first
- optional severity after toggle

## Step 5 — Connect to recommendation logic
Map symptom/profile information to venue and event tags.

Example:
- quiet speech → quieter spaces
- instability → step-free / seating
- fatigue → short-duration events / seating
- anxiety → less crowded / calmer places

## Step 6 — Connect to matching logic
Use symptom clusters and social difficulty patterns as part of matching.

## Step 7 — Keep the tone non-clinical
Review all copy to ensure:
- plain English
- warm tone
- no unnecessary medical jargon
- explanation of user benefit when requesting data

---

# Final Design Decision Summary

## Keep
- short onboarding
- plain-language symptom cards
- one-side/both/all-over question
- optional detailed symptom profile later
- best time of day / medication-window style input
- visible vs invisible challenge distinction

## Reduce
- long medical checklists
- Latin/clinical terms in onboarding
- sliders everywhere
- mandatory detail entry

## Avoid
- full body drawing interaction as main input
- making the app feel like a symptom tracker
- collecting data without showing its value immediately

---

# One-Sentence Product Rule

**Collect only the symptom information that improves social matching and place recommendations, and present it in a warm, plain-language way that never makes onboarding feel clinical.**
