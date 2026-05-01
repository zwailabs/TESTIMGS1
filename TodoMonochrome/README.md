# TodoMonochrome (iPhone-only, black/gray/white)

Modern, basic Todo list built with SwiftUI and a strict monochrome palette (black / grays / white).

## Build an IPA on GitHub Actions (no Mac needed)

1. Push this repo to GitHub.
2. Go to `Actions -> Build unsigned IPA -> Run workflow`.
3. Download the artifact `TodoMonochrome-unsigned-ipa` -> `TodoMonochrome-unsigned.ipa`.
4. Open **Sideloadly** on your PC -> select the `.ipa` -> install to your iPhone (it will re-sign with your Apple ID).

Notes:
- This workflow builds an unsigned IPA (Sideloadly handles signing).
- On iOS 16+, you may need to enable Developer Mode on the iPhone to run sideloaded apps.

## Run in Xcode (optional)

- `brew install xcodegen`
- `cd TodoMonochrome && xcodegen generate`
- Open `TodoMonochrome/TodoMonochrome.xcodeproj`

## What you get

- Add / complete / delete todos
- "Clear completed"
- Local persistence to a JSON file in the app's Documents directory
- Monochrome UI (no colored accents)
- Home Screen widget with `+` shortcut and upcoming todos

## Requirements

- iOS 16+ (uses `NavigationStack`)
