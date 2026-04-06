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

## [2026-03-11] - Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed) - Continued

### Prompt:
Please continue to step 2.6

### Added
- **`lib/widgets/hunt_card.dart`**: Created a polished `HuntCard` widget to display hunt details (title, description, rating, difficulty).
- **`test/widgets/hunt_card_test.dart`**: Created a widget test to verify `HuntCard` displays information correctly.

## [2026-03-11] - Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed) - Finalized

### Prompt:
Please proceed to step 2.7

### Added
- **`lib/screens/hunt_detail_screen.dart`**: Implemented a detailed view for hunts, including full description, riddle, and "Start Hunt" placeholder.
- **`test/screens/hunt_detail_screen_test.dart`**: Created a widget test to verify `HuntDetailScreen` displays all details correctly.

### Changed
- **`lib/screens/discovery_screen.dart`**: Implemented navigation to `HuntDetailScreen` when a `HuntCard` is tapped.
- **`lib/screens/hunt_detail_screen.dart`**: Removed coordinate display from the detail view to preserve gameplay mystery.
- **`test/screens/hunt_detail_screen_test.dart`**: Updated test to verify coordinates are no longer visible.
- **`about/requirements.md`**: Marked Step 2.7 as complete, finalizing Phase 2.

## [2026-03-11] - Phase 3: Authentication & Identity

### Prompt:
I think we're ready. Time to begin Phase 3... Please proceed with step 3.1.

### Added
- **Dependencies**: Added `google_sign_in: ^6.2.1` and `mocktail: ^1.0.4` to `pubspec.yaml` for authentication and testing.
- **`lib/services/auth_service.dart`**: Created `AuthService` handling Email/Password, Google Sign-In, and password reset via `firebase_auth`.
- **`test/services/auth_service_test.dart`**: Created comprehensive unit tests using `mocktail` to verify `AuthService` behavior.

### Changed
- **`about/requirements.md`**: Marked Step 3.1 as complete.

### Changed
- **`lib/screens/discovery_screen.dart`**: Integrated `HuntCard` into the hunt list.
- **`about/requirements.md`**: Marked Step 2.6 as complete.

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

## [2026-04-05] - Phase 3: Authentication & Identity - Continued

### Prompt:
Please update any necessary files with up to date code

### Added
- **`lib/providers/auth_providers.dart`**: Implemented `authServiceProvider` and `authStateProvider` to expose authentication state to the app.
- **`lib/screens/login_screen.dart`**: Created a login screen with Email/Password and Google Sign-in options.
- **`lib/screens/registration_screen.dart`**: Created a registration screen for new user sign-ups.
- **`lib/widgets/auth_gate.dart`**: Created the `AuthGate` widget to listen to auth state and route users to either `LoginScreen` or `HuntDiscoveryScreen`.
- **`test/widgets/auth_gate_test.dart`**: Added widget tests for `AuthGate`.
- **`test/screens/login_screen_test.dart`**: Added widget tests for `LoginScreen`.
- **`test/screens/registration_screen_test.dart`**: Added widget tests for `RegistrationScreen`.

### Added
- **`lib/screens/discovery_screen.dart`**: Added a logout button to the `AppBar` that allows users to sign out via `AuthService`.

### Changed
- **`lib/services/auth_service.dart`**: Fixed Google Sign-In and Sign-Out implementation for `google_sign_in` 7.2.0. Implemented mandatory `initialize()`, switched to `authenticate()`, and updated token retrieval to use the new `authorizationClient.authorizeScopes()` flow. Added platform checks and an `isTest` flag to prevent crashes/freezes on Windows, where native Google Sign-In is not supported.
- **`lib/screens/login_screen.dart`**: Updated Google Sign-In error handling to display the actual error message (e.g., "UnsupportedError" on Windows) to the user via a SnackBar.
- **`test/services/auth_service_test.dart`**: Updated unit tests to match the new 7.2.0 API and added `isTest: true` to bypass platform checks during testing.
- **`lib/main.dart`**: Replaced `HuntDiscoveryScreen` with `AuthGate` as the default home widget to properly enforce authentication.
- **`about/requirements.md`**: Marked Step 3.2 as complete.

## [2026-04-05] - Phase 4: GPS Service & Hunt Creation

### Prompt:
The issues with logging out and signing in with google still exist, but we can fix them after establishing the app's functionability. So, please begin Phase 4 step 4.1.

### Added
- **Dependencies**: Added `google_maps_flutter: ^2.10.0` and `geolocator: ^13.0.2` to `pubspec.yaml`.
- **`lib/services/location_service.dart`**: Implemented `LocationService` to handle permissions, current location, and distance calculations.
- **`lib/providers/location_providers.dart`**: Created Riverpod providers for `LocationService`, current position, and location stream.
- **`lib/screens/hunt_gameplay_screen.dart`**: Created the gameplay screen featuring a Google Map, real-time location tracking, and distance-based geofencing to trigger hunt completion.
- **`lib/screens/map_picker_screen.dart`**: Created a map selection screen to allow users to pick target coordinates on a map.
- **`test/services/location_service_test.dart`**: Added unit tests for distance calculation logic.

### Changed
- **`android/app/src/main/AndroidManifest.xml`**: Added `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` permissions and Google Maps API key metadata.
- **`ios/Runner/Info.plist`**: Added `NSLocationWhenInUseUsageDescription` and `NSLocationAlwaysUsageDescription`.
- **`lib/screens/hunt_detail_screen.dart`**: Updated the "START HUNT" button to navigate to the new `HuntGameplayScreen`.
- **`about/requirements.md`**: Marked Step 4.1 as complete.
