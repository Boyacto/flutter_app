# 💰 Saving Jar Demo

A hackathon-ready Flutter app that demonstrates **round-up savings** with a clean architecture, beautiful UI, and micro-interactions. Think "카카오뱅크 저금통" but with a mock Capital One API integration.

![Flutter](https://img.shields.io/badge/Flutter-3.9.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?logo=dart)

## ✨ Features

### 🎯 Core Functionality
- **Auto Round-Up**: Automatically save spare change from purchases
- **Smart Rules**: Configure round-up unit ($0.50, $1, $5, $10)
- **Weekend 2× Bonus**: Double your savings on weekends
- **Category Filters**: Include/exclude specific spending categories
- **Daily & Weekly Caps**: Set spending limits
- **Pause Feature**: Temporarily pause round-ups
- **Goal Tracking**: Set savings goals with progress visualization
- **Activity History**: View all round-ups, top-ups, and skips

### 🎨 Design System
- **Design Tokens**: Single source of truth for colors, spacing, typography
- **Light/Dark Themes**: 4.5:1 contrast ratio for accessibility
- **Consistent Spacing**: 4px, 8px, 12px, 16px, 20px, 24px, 32px
- **Motion Timings**: Fast (120ms), Normal (240ms), Celebrate (800ms)

### 🎬 Micro-interactions
- **Coin Drop Animation**: 150-300ms coin falling into progress ring
- **Ring Pulse**: 120ms pulse effect on round-up success
- **Count-Up Animation**: 250-350ms smooth number transitions
- **Milestone Badges**: Unlock animations at 25%, 50%, 75%, 100%
- **Confetti Overlay**: 800ms celebration at goal completion
- **Spring Tap Effects**: 80ms spring animation on chip selections
- **Reduce Motion**: Accessibility toggle for minimal animations

### 📱 Screens
1. **Onboarding** - 4-step introduction with pagination dots
2. **Home** - Goal card, today/week summary, quick top-up, auto toggle
3. **Activity** - Event list with filters (All, Round-ups, Skips)
4. **Rules** - Round-up unit, weekend bonus, categories, limits, pause
5. **Goal** - Editable goal, milestone badges, empty jar action
6. **Settings** - Language (English/Korean), theme, reduce motion, reset
7. **Simulate** - Mock purchase generator with amount/category/merchant

## 🏗️ Architecture

```
lib/
├── theme/
│   ├── tokens.dart           # Design tokens (colors, spacing, typography)
│   └── app_theme.dart         # Light/dark ThemeData
├── core/
│   ├── models/                # Data models (Jar, RuleSet, Limit, Event, etc.)
│   ├── services/              # Business logic (mock API, round-up engine, storage)
│   ├── utils/                 # Utilities (currency, date formatters)
│   └── widgets/               # Shared widgets (ProgressRing, GoalCard, EventList, etc.)
├── state/
│   └── providers.dart         # Riverpod state providers
├── features/
│   ├── onboarding/
│   ├── home/
│   ├── activity/
│   ├── rules/
│   ├── goal/
│   ├── settings/
│   └── simulate/
├── app_router.dart            # Route configuration
└── main.dart                  # App entry point
```

## 🧮 Round-up Logic

```dart
// Formula: ceil(amount / unit) * unit - amount
// Example: $12.35 with $1 unit = $13.00 - $12.35 = $0.65

Rules:
✓ Integer amounts → $0 (no spare change)
✓ Weekend multiplier (2×) applied if enabled
✓ Category include/exclude filters
✓ Daily/weekly caps enforced
✓ Pause state respected
```

**Skip Reasons**:
- `integer`: Whole dollar amount (no spare change)
- `cap`: Daily or weekly limit reached
- `paused`: Round-ups temporarily paused
- `category`: Excluded by category filter

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.0+
- Dart SDK 3.9.0+

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd flutter_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Run Tests

```bash
flutter test
```

### Analyze Code

```bash
flutter analyze
```

## 📦 Dependencies

- **flutter_riverpod** ^2.6.1 - State management
- **intl** ^0.19.0 - Internationalization & formatting
- **flutter_svg** ^2.0.10+1 - SVG support
- **shared_preferences** ^2.3.2 - Local storage
- **flutter_lints** ^5.0.0 - Linting rules

## 🎮 Demo Script (90s)

1. **Launch** → Onboarding flow (4 screens)
2. **Home** → Empty jar with $200 goal
3. **Simulate** → Create purchase ($25.30)
   - Watch coin drop animation
   - Ring pulse + count-up
   - Toast: "+$0.70 saved!"
4. **Quick Top-Up** → Add $3
5. **Rules** → Enable Weekend 2× → Simulate weekend purchase
6. **Activity** → View round-ups and skips
7. **Goal** → 75% milestone unlocked
8. **Settings** → Toggle dark mode

## 🎨 Design Tokens Reference

### Colors
- **Primary**: Mint600 (#10B981)
- **Accent**: Amber500 (#F59E0B), Teal500 (#14B8A6)
- **Grays**: Gray900, 700, 500, 200, 100, 50
- **Semantic**: ErrorRed, SuccessGreen, WarningAmber

### Motion
- **Fast**: 120ms (ring pulse, chip tap)
- **Normal**: 240ms (transitions)
- **Slow**: 400ms (page transitions)
- **Celebrate**: 800ms (confetti, milestone unlock)

### Typography
- **Display**: 48px, bold, -0.5 letter-spacing
- **Title**: 24px, semibold, -0.3 letter-spacing
- **Body**: 16px, regular
- **Label**: 14px, semibold, 0.1 letter-spacing
- **Caption**: 12px, regular

## 🌍 Localization

The app supports:
- **English** (en_US)
- **Korean** (ko_KR)

Copy examples:
- Round-up success: `"{merchant} {amount} — 잔돈 +{delta} 적립!"`
- Skip (cap): `"오늘 한도에 도달했어요. 내일 다시 모을게요."`
- 75% milestone: `"와—75%! 거의 다 왔어요."`

## ♿ Accessibility

- **Contrast**: 4.5:1 minimum for all text
- **Screen Reader**: Labels on all interactive icons
- **Reduce Motion**: Toggle to minimize animations
- **Touch Targets**: Minimum 44×44 logical pixels

## 🐛 Known Issues

- RadioListTile deprecation warnings (Flutter 3.32+) - informational only
- No actual bank integration (mock API only)

## 📄 License

This is a demo project created for hackathon purposes.

## 🙏 Acknowledgments

- Inspired by 카카오뱅크 저금통 (Kakao Bank Piggy Bank)
- Mock Capital One API integration
- Flutter & Riverpod communities

---

**Built with Flutter** 💙 **Powered by Riverpod** ⚡
