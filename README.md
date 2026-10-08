# AEVA iOS — Codemagic + TestFlight ready

SwiftUI companion app with Live Activities (Dynamic Island), chat, and bond system.

## Structure

```
Aeva/
├── project.yml              # XcodeGen specification
├── codemagic.yaml           # Codemagic CI → TestFlight
├── README.md
├── Sources/
│   ├── Aeva/                # Main app target
│   └── AevaWidget/          # Widget Extension (Live Activity)
└── Resources/
    └── Assets.xcassets
```

## Requirements

- iOS 16.2+
- Xcode 15+
- XcodeGen (`brew install xcodegen`)
- Apple Developer Program membership
- App Store Connect API Key

## Local setup

```bash
cd Aeva
xcodegen generate
open Aeva.xcodeproj
```

## Codemagic → TestFlight

### 1. Apple side
1. Create the app on App Store Connect with Bundle ID `com.aeva.app`
2. Create an App Store Connect API Key (Users and Access → Integrations → App Store Connect API)
   - Role: **App Manager**
   - Download the `.p8` file (only once)
   - Note the **Issuer ID** and **Key ID**

### 2. Codemagic side
1. Connect the GitHub repo to Codemagic
2. Team settings → Integrations → Developer Portal → Add the API key
   - Name it exactly `Aeva` (or change the name in `codemagic.yaml` → integrations)
3. Start the workflow **Aeva → TestFlight**

Codemagic will:
- Generate the Xcode project
- Fetch/create certificates & profiles automatically
- Sign the app
- Build the IPA
- Upload it to TestFlight

### Bundle IDs
- App: `com.aeva.app`
- Widget: `com.aeva.app.widget`

## Features
- Presence view with animated aura + Dynamic Island controls
- Chat with bond-aware responses
- Bond percentage that reacts to message tone
- Live Activity / Dynamic Island showing bond % and mood
