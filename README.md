# FinPlay

**Interactive Gamification — Finance Simulation Game**

FinPlay is a Flutter application that teaches corporate finance through interactive,
gamified simulations. Players make financing, investing, and operating decisions across
multiple rounds, react to market shocks, and see the impact on their company's financial
statements in real time. It supports both facilitator-led classroom sessions and
self-paced individual learning, alongside a library of standalone education modules and
finance tools.

## Features

- **Simulation game** — multi-round company simulation (financing, investing, operating
  modules) with live financial statements, charts, and AI tooltips.
- **Two play modes**
  - *Facilitator-led* — a facilitator runs a live session; up to 7 teams join a lobby and
    compete, synced over WebSockets with shared timers and market shocks.
  - *Self-paced* — individual learners log in and progress through scenarios at their own
    pace, with saved progress.
- **Market shocks** — dynamic events injected during play, with in-app notifications and
  an active-shocks display.
- **Education hub** — the FinPlay curriculum: 14 content modules with slides, quizzes,
  ordering games, statement-builder and case-scenario activities, plus 2 workshop tools
  (break-even, capital budgeting) and the simulation. The lineup is defined once in
  `lib/data/education_catalog.dart`, mirroring the website's `shared/education-catalog.ts`;
  modules are referred to by title or permanent catalog id, never by card position.
  Eight content modules ship in the app; the rest open on the website until ported.
- **Finance tools** — WACC, DuPont analysis, working capital, credit rating, covenants,
  cap table, dividends, financial ratios, an Excel-style statement view, and a glossary.
- **Dashboards** — team comparison, multi-round dashboards, and a game-map overview.
- **Assessment** — pre/post knowledge tests to measure learning gains.
- **Research** — built-in instruments for DBA/academic data collection.
- **Bilingual** — English and Arabic (with RTL support), light/dark themes.

## Tech Stack

- **Flutter** (Dart SDK `^3.10.4`), Material Design
- **State management** — `flutter_riverpod` + `riverpod_annotation`
- **Navigation** — `go_router`
- **Networking** — `dio` (REST), `socket_io_client` (real-time sessions)
- **Storage** — `shared_preferences`
- **UI / charts** — `flutter_animate`, `shimmer`, `fl_chart`, `google_fonts`, `qr_flutter`
- **Localization** — `flutter_localizations` (en / ar)

Backend API: `https://finplay.viftraining.com`

## Project Structure

```
lib/
├── main.dart                 # App entry point, ProviderScope, MaterialApp.router
├── app/
│   ├── router/               # go_router route definitions
│   ├── theme/                # Colors, light/dark themes
│   └── i18n/                 # App strings (en / ar)
├── core/
│   ├── network/              # API client, endpoints, socket service
│   ├── services/             # Cache service
│   └── utils/                # Constants
├── data/
│   ├── models/               # Domain models (team, game_state, scenario, shock, …)
│   ├── repositories/         # Data access (game, auth, decision, education, …)
│   └── *.dart                # Static scenario / educational content
├── providers/                # Riverpod providers (auth, game_state, socket, theme, …)
├── shared/widgets/           # Reusable widgets (timers, charts, cards, badges, …)
└── features/                 # Feature modules, each with screens/ + widgets/
    ├── onboarding/           # Splash, mode + program selectors, home
    ├── auth/                 # Site access, self-paced login, password reset
    ├── lobby/                # Team lobby for facilitator-led sessions
    ├── simulation/           # Core simulation gameplay
    ├── facilitator/          # Facilitator controls + admin model editor
    ├── dashboard/            # Team comparison, multi-round, game map
    ├── education/            # Education hub + finance tool screens
    ├── gov_education/        # Education module screens + games (legacy folder name)
    ├── assessment/           # Pre/post knowledge tests
    ├── research/             # Research data collection
    └── shocks/               # Market shock UI
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) with Dart `^3.10.4`
- An Android/iOS device or emulator, or a browser for web

### Install & Run

```bash
flutter pub get      # install dependencies
flutter run          # run on a connected device / emulator
```

Run on a specific platform:

```bash
flutter run -d chrome    # web
flutter run -d ios       # iOS simulator
flutter run -d android   # Android emulator
```

### Build

```bash
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

### Test

```bash
flutter test
```

## Assets & Icons

- Fonts: JetBrains Mono (bundled), plus Google Fonts at runtime.
- App icons / splash are generated via `flutter_launcher_icons` and
  `flutter_native_splash`:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Localization

The app ships with English and Arabic. Strings live in `lib/app/i18n/app_strings.dart`,
and the active locale is managed by `lib/providers/locale_provider.dart`.

---

Built with Flutter for VIF Training.
