# Radiofy 🎧

<p>
  <img alt="Platform" src="https://img.shields.io/badge/platform-iOS-000000?logo=apple&logoColor=white">
  <img alt="iOS" src="https://img.shields.io/badge/iOS-26.2+-000000">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white">
  <img alt="SwiftUI" src="https://img.shields.io/badge/SwiftUI-0055FF?logo=swift&logoColor=white">
  <img alt="Xcode" src="https://img.shields.io/badge/Xcode-26-147EFB?logo=xcode&logoColor=white">
</p>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-2.7.0-2ea44f">
  <img alt="SPM" src="https://img.shields.io/badge/SPM-compatible-FA7343?logo=swift&logoColor=white">
  <img alt="i18n" src="https://img.shields.io/badge/i18n-EN_·_FR-blue">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-lightgrey">
</p>

> Listen to radio stations from anywhere in the world.

Radiofy lets you browse and search thousands of live radio stations, keep your
favourites one tap away, and carry playback across the whole app with a mini
player docked to the tab bar.

---

## 📸 Screenshots

| Onboarding | Radio | Player | Library |
|:---:|:---:|:---:|:---:|
| <img src="Screenshots/onboarding.png" width="200"> | <img src="Screenshots/radio.png" width="200"> | <img src="Screenshots/player.png" width="200"> | <img src="Screenshots/library.png" width="200"> |

---

## ✨ Features

- 🌍 **Browse stations worldwide** — filter by country and tag, paginated
- 🔎 **Search** any station by name
- ▶️ **Persistent mini player** — docked to the tab bar, expands to a full player, keeps playing while you navigate
- ❤️ **Favourites & recently played** for one-tap access
- 🎙 **Podcasts** with episode lists parsed from RSS
- 🔐 **Accounts** — email sign-up with six-digit verification, password reset, and Sign in with Apple
- 🌓 **Dark interface** built for listening at night
- 🌐 **English and French**, fully localised

---

## 📱 Requirements

| | |
|---|---|
| **iOS** | 26.2+ |
| **Xcode** | 26 |
| **Swift** | 5 |
| **Dependency manager** | Swift Package Manager |

---

## 🚀 Getting started

```bash
git clone git@github.com:fabricetiennette/Radiofy-iOS.git
cd Radiofy-iOS
open Radiofy.xcodeproj
```

Swift Package Manager resolves everything on first open — no `pod install`, no
`.xcworkspace`.

### Point the app at an API

Radiofy talks to its own REST API. The base URL is injected through build
settings rather than hardcoded, so you can switch environments without touching
code:

```
Resources/Config/Staging.xcconfig  →  Info.plist  →  AppConfig
```

```
RADIOFY_API_BASE_URL = https:$(SLASH)$(SLASH)your-api-host
RADIOFY_API_VERSION  = v1
```

`AppConfig` fails fast with an explicit message if the key is missing, instead of
silently falling back to a default host.

Then pick the **Radiofy** scheme and run.

---

## 🏗 Architecture

**MVVM**, with composition handled outside the views.

Dependencies are created once in `AppContainer` and passed down explicitly — no
singletons, no ambient globals. Each screen owns a small `Module` whose only job
is to wire a view model to its view:

```swift
struct RadioModule {
    let authService: AuthServicing
    let radioService: RadioServicing

    @MainActor
    func makeView() -> some View {
        let viewModel = RadioViewModel(authService: authService, radioService: radioService)
        return RadioView(viewModel: viewModel)
    }
}
```

Every service sits behind a protocol (`AuthServicing`, `RadioServicing`,
`HealthServicing`), so view models are testable with mocks and SwiftUI previews
never touch the network.

### Project structure

```
Radiofy/
├── Source/            App entry, AppContainer, RootView, RootRouter
├── Manager/
│   ├── Auth/          Auth service, AuthSession, Keychain store, Apple Sign In
│   ├── RadioStation/  Radio service, endpoints, DTO → domain mapping
│   ├── Podcast/       RSS parsing
│   └── Health/        Reachability check on launch
├── Scene/
│   └── <Feature>/     One folder per screen: Module · ViewModel · View
├── Common/            Shared types (LoadState)
├── Helpers/           Reusable SwiftUI components
└── Resources/         Assets, translations, xcconfig
```

### Async UI state

Screens that load something share one state type instead of juggling an
`isLoading` flag next to an `errorMessage` string — the two can no longer
contradict each other:

```swift
enum LoadState: Equatable {
    case idle, loading, loaded
    case failed(String)
}
```

View models keep exposing `isLoading` and `errorMessage` as computed properties,
so views read them unchanged.

### Session handling

Only the **refresh** token is persisted, in the Keychain, and it is read off the
main actor since Keychain access can block. The short-lived **access** token
never touches disk — it lives in memory inside an `actor`, so concurrent
requests serialise their reads and writes without a data race:

```swift
public actor AuthSession {
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
}
```

Token rotation is handled: when the server issues a new refresh token, it
replaces the stored one. On launch the app restores the session and validates it
against the API before showing the main tabs.

---

## 🌐 API

| Endpoint | Purpose |
|----------|---------|
| `POST /v1/auth/register` · `/login` · `/refresh` | Account creation and session lifecycle |
| `POST /v1/auth/apple` | Sign in with Apple — identity token verified server-side |
| `POST /v1/auth/verify-email` · `/verify-email/resend` | Six-digit code verification |
| `POST /v1/auth/forgot-password` · `/reset-password` | Password reset by code |
| `GET` · `DELETE /v1/user/me` | Profile and account deletion |
| `GET /v1/radio/stations` | Browse — `countryCode`, `tag`, `limit`, `offset` |
| `GET /v1/radio/stations/search` | Search — `q`, `limit`, `offset` |
| `GET /v1/radio/stations/{uuid}/stream-url` | Resolve a playable stream URL |

---

## 📦 Dependencies

| Package | Role |
|---------|------|
| [FRadioPlayer](https://github.com/fethica/FRadioPlayer) | Radio streaming engine |
| [LNPopupController](https://github.com/LeoNatan/LNPopupController) | Mini player expanding into a full player |
| [SDWebImage](https://github.com/SDWebImage/SDWebImage) | Async image loading and caching |
| [Lottie](https://github.com/airbnb/lottie-ios) | Launch and transition animations |
| [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) | Loading indicators |
| [FeedKit](https://github.com/nmdias/FeedKit) | Podcast RSS parsing |
| [Alamofire](https://github.com/Alamofire/Alamofire) | Networking on legacy screens — newer services use `URLSession` |
| [Reusable](https://github.com/AliSoftware/Reusable) | Type-safe cell and view reuse |

### Tooling

- **[SwiftLint](https://github.com/realm/SwiftLint)** — runs as a build phase before compilation, so style violations fail the build
- **[SwiftGen](https://github.com/SwiftGen/SwiftGen)** — type-safe assets and strings: `L10n.radio` instead of a raw key

---

## 🗺 Roadmap

- Search tab wired to the stations API
- Stream URLs resolved through the API and handed to the player
- Favourites and recently played persisted server-side instead of `UserDefaults`
- Settings and Subscription rebuilt in SwiftUI

---

## 👤 Author

**Fabrice Etiennette** — [@fabricetiennette](https://github.com/fabricetiennette)

## 📄 License

Released under the [MIT License](LICENSE).
