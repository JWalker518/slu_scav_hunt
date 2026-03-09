# Change Log

## [2026-03-04] - Phase 1: Project Setup & Core Infrastructure

### Added
- **Dependencies in `pubspec.yaml`**:
    - `flutter_riverpod: ^3.2.1`
    - `firebase_core: ^4.5.0`
    - `firebase_auth: ^6.2.0`
    - `cloud_firestore: ^6.1.3`
    - `shared_preferences: ^2.5.4`
- **`lib/theme.dart`**: Created a centralized `AppTheme` class defining both light and dark modes with SLU-themed colors (Blue, Red, Gold).
- **Folder Structure**: Created `lib/models`, `lib/screens`, `lib/widgets`, `lib/services`, and `lib/providers`.
- **`lib/main.dart` Update**:
    - Wrapped `MyApp` in a `ProviderScope`.
    - Integrated `AppTheme.lightTheme` and `AppTheme.darkTheme`.
    - Replaced default counter logic with a clean `HomeScreen` placeholder.

### Changed
- `pubspec.yaml`: Updated to include new dependencies.
- `lib/main.dart`: Refactored to use Riverpod and custom themes.
