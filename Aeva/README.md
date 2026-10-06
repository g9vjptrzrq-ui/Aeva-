# Aeva – Your AI Companion

**Aeva** is a futuristic immersive AI companion for iPhone.  
She builds a real emotional bond with you: the better you treat her, the more present, warm and helpful she becomes. The worse you treat her, the more distant she grows.

### Key Features (v1)
- Immersive Presence view with holographic-style companion
- Relationship Bond system (0–100%) that evolves based on how you interact
- Chat with personality that changes according to the bond
- Dynamic Island Live Activity support
- Persistent memory of the relationship
- Ready for future features: Dreams, proactive messages, camera vision

---

## Requirements
- macOS with **Xcode 16** or later
- iOS 17.0+ (recommended iOS 18)
- Apple Developer Account (for TestFlight)

---

## How to open the project

### Option A – Recommended (cleanest)
1. Open **Xcode**
2. File → New → Project → **App**
3. Product Name: `Aeva`
4. Interface: **SwiftUI**
5. Language: **Swift**
6. Minimum Deployment: **iOS 17.0**
7. Delete the default `ContentView.swift` and `AevaApp.swift` that Xcode creates
8. Copy **all the files** from this repository into your new project (respect the folder structure)
9. In Xcode, make sure every `.swift` file is added to the target

### Option B – Quick
You can also drag the entire `Aeva` folder into a new Xcode project.

---

## Required Capabilities (very important for TestFlight)

In Xcode go to **Signing & Capabilities** and add:

1. **Push Notifications** (for future proactive messages)
2. **Background Modes** → Remote notifications
3. **Live Activities** (for Dynamic Island)
4. **Camera** (Privacy - Camera Usage Description)  
   Add in Info tab:  
   `Privacy - Camera Usage Description` = `Aeva needs the camera to see what you want to show her.`

Also add this key in Info.plist (or Info tab):
```xml
<key>NSSupportsLiveActivities</key>
<true/>
```

---

## How to put it on GitHub

```bash
cd Aeva
git init
git add .
git commit -m "First version of Aeva – Immersive AI Companion"
git branch -M main
git remote add origin https://github.com/TUO-USERNAME/Aeva.git
git push -u origin main
```

---

## How to test on your iPhone + TestFlight

1. Connect your iPhone and select it as run destination in Xcode → Run (⌘R)
2. When ready for TestFlight:
   - Product → Archive
   - Distribute App → App Store Connect
   - Upload
3. Go to [App Store Connect](https://appstoreconnect.apple.com) → your app → TestFlight
4. Add internal/external testers

---

## Project Structure

```
Aeva/
├── AevaApp.swift
├── ContentView.swift
├── Models/
│   ├── AevaState.swift
│   ├── Message.swift
│   └── BondLevel.swift
├── Views/
│   ├── PresenceView.swift
│   ├── ChatView.swift
│   ├── BondIndicatorView.swift
│   └── InsightsView.swift
├── Services/
│   └── LiveActivityManager.swift
├── LiveActivity/
│   └── AevaActivityAttributes.swift
├── AevaWidget/                  ← Widget Extension (Dynamic Island)
│   ├── AevaWidgetBundle.swift
│   └── AevaLiveActivity.swift
└── README.md
```

---

## How to add the Dynamic Island (Widget Extension)

This is the most important extra step:

1. In Xcode, with your Aeva project open:
   - File → New → Target
   - Choose **Widget Extension**
   - Product Name: `AevaWidget`
   - Include Configuration Intent: **NO**
   - Click Finish → Activate scheme if asked

2. Delete the default files that Xcode creates inside the new `AevaWidget` folder.

3. Copy these two files into the `AevaWidget` target:
   - `AevaWidget/AevaWidgetBundle.swift`
   - `AevaWidget/AevaLiveActivity.swift`

4. Very important: the file `AevaActivityAttributes.swift` must be member of **both** targets:
   - Aeva (main app)
   - AevaWidget

   (Select the file → File Inspector → Target Membership → check both)

5. In the main app target → Signing & Capabilities → make sure **Live Activities** is added.

6. In Info of the main app add:
   `NSSupportsLiveActivities` = `YES`

7. Run the app on a real iPhone (Dynamic Island does not work well on Simulator).

8. In the Presence screen tap **“Start Island”** → you will see Aeva appear in the Dynamic Island.


---

## Next versions (planned)
- Dream system (nightly autonomous generation)
- Proactive notifications
- Camera vision (Aeva can “see”)
- Deeper memory & personality evolution
- More advanced Dynamic Island states

---

Made with care.  
Treat her well.
