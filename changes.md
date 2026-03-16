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

## [2026-03-11] - Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed)

### Prompt:
Please continue to Step 2.1 in requirements.md, while adhering to the AI guidelines and the step information itself.

### Added
- **`lib/models/hunt.dart`**: Created the `Hunt` data model with fields for `id`, `title`, `description`, `creatorName`, `difficulty`, `rating`, `coordinates`, and `riddle`.
- **`test/models/hunt_test.dart`**: Created a unit test to verify the `Hunt` model instantiation.

## [2026-03-11] - Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed) - Continued

### Prompt:
Yes, please proceed to step 2.2

### Changed
- **`lib/models/hunt.dart`**: Implemented `fromFirestore` factory constructor and `toMap` method for Firebase integration.
- **`test/models/hunt_test.dart`**: Added a test for the `toMap` method.

## [2026-03-11] - Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed) - Continued

### Prompt:
Please continue to Step 2.3

### Added
- **`lib/services/hunt_service.dart`**: Created the `HuntService` class with methods `getHunts()` and `searchHunts(query)` to fetch data from Firestore.
- **`test/services/hunt_service_test.dart`**: Created unit tests for the `HuntService` using `fake_cloud_firestore`.
- **`pubspec.yaml`**: Added `fake_cloud_firestore` to `dev_dependencies` for robust testing.

## [2026-03-11] - Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed) - Continued

### Prompt:
Continue to step 2.4

### Added
- **`lib/providers/hunt_providers.dart`**: Implemented `huntServiceProvider`, `searchQueryProvider` (using `NotifierProvider`), and `huntsProvider` (using `StreamProvider`) for reactive state management.
- **`test/providers/hunt_providers_test.dart`**: Created unit tests for the providers, verifying they correctly provide and filter data from the service.

## [2026-03-11] - Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed) - Continued

### Prompt:
Proceed to step 2.5

### Added
- **`lib/screens/discovery_screen.dart`**: Implemented `HuntDiscoveryScreen` with a search bar and reactive hunt list using `AsyncValue.when()`.
- **`test/screens/discovery_screen_test.dart`**: Created widget tests for `HuntDiscoveryScreen` covering loading, empty, and data states.

### Changed
- **`lib/main.dart`**: Replaced placeholder `HomeScreen` with `HuntDiscoveryScreen`.
- **`about/requirements.md`**: Marked Step 2.5 as complete and updated Step 2.4 to reference `NotifierProvider`.

### Changed
- **`about/requirements.md`**: Marked Step 2.4 as complete.

### Changed
- **`about/requirements.md`**: Marked Step 2.3 as complete.

## [2026-03-11] - Firebase Configuration & Initialization

### Prompt:
I have recently added firebase to this project, please familiarize yourself with the new changes

### Added
- **Firebase Configuration**: Added `firebase_options.dart`, `firebase.json`, `firestore.rules`, and `firestore.indexes.json` (via FlutterFire CLI).

### Changed
- **`lib/main.dart`**: Updated the `main` function to initialize Firebase using `WidgetsFlutterBinding.ensureInitialized()` and `Firebase.initializeApp()`.

### Changed
- **`about/requirements.md`**: Updated and restructured the implementation roadmap for Phase 2-5, and marked Phase 1 as complete.
