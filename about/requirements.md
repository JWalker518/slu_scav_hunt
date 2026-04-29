# Project Requirements: Hunt App 
Developer: James Walker 
Description: This app is designed to give users a unique experience of creating their own scavenger hunts using GPS that
                can be shared to others to complete
 
  
## AI Assistant Guardrails 
Gemini: When reading this file to implement a step, you MUST adhere to the following architectural rules: 
 
1.	State Management: Use flutter_riverpod exclusively. Do not use setState for complex logic. 

2.	Architecture: Maintain strict separation of concerns: 
    ●	/models: Pure Dart data classes (use json_serializable or freezed if helpful). 
    ●	/services: Backend/API communication only. No UI code. 
    ●	/providers: Riverpod providers linking services to the UI. 
    ●	/screens & /widgets: UI only. Keep files small. Extract complex widgets into their own files. 

3.	Local Storage: Use shared_preferences for local app state (e.g., theme toggles, onboarding status). 

4.	Database: Use [Firebase Firestore OR PostgreSQL] for persistent cloud data. 

5.	Stepwise Execution: Only implement the specific step requested in the prompt. Do not jump ahead. 

6.  Committing to Github: Commit and push all changes that have taken place already before enacting the new prompt given.

7.  Notation: In the file named "changes.md", please briefly list any changes made after a given prompt. For each new note added to change.md, please put the prompt that was given above it for organizational purposes. Keep it organized.

8. Testing: After each step in requirements.md you implement, create a test for it in the test folder.

  
## Implementation Roadmap 
Phase 1: Project Setup & Core Infrastructure 

    [x] Step 1.1: Dependencies & Theme 
        -	Add Riverpod, Firebase Core, Firebase Auth, Cloud Firestore, and Shared Preferences to pubspec.yaml. 
        -	Create a centralized ThemeData class in lib/theme.dart (colors, typography). 

    [x] Step 1.2: Base Architecture 
        -	Set up the folder structure (models, screens, widgets, services, providers). 
        -	Wrap MyApp in a ProviderScope. 

Phase 2: Milestone 1 - Hunt Discovery (The MVP Feed)
Goal: Establish the core "Hunt Discovery" feed using live Firestore data. This focuses on browsing community hunts before adding GPS or creation logic.

    [x] Step 2.1: Hunt Data Model
        - Create a Hunt model in lib/models/hunt.dart (fields: id, title, description, creatorName, difficulty, rating, coordinates, and riddle).

    [x] Step 2.2: Firebase implementation
        - Implement fromFirestore and toMap for seamless Firebase integration.

    [x] Step 2.3: Hunt Discovery Service
        - Implement HuntService in lib/services/hunt_service.dart.
        - Add logic to fetch a stream or list of available hunts from the "hunts" collection in Firestore.

    [x] Step 2.4: State Management (Providers)
        - Create a huntsProvider (StreamProvider) in lib/providers/hunt_providers.dart to expose the hunt list.
        - Add a searchQueryProvider (NotifierProvider) to handle real-time filtering of the list.

    [x] Step 2.5: Discovery Screen UI
        - Create HuntDiscoveryScreen in lib/screens/discovery_screen.dart.
        - Use a ListView.builder or GridView to display hunts.
        - Implement AsyncValue.when() to handle loading and error states gracefully.

    [x] Step 2.6: Hunt Card Widget
        - Extract the hunt item UI into a dedicated HuntCard in lib/widgets/hunt_card.dart.
        - Include visual indicators for difficulty, estimated time, or user ratings.

    [x] Step 2.7: Navigation & Details
        - Create a HuntDetailScreen in lib/screens/hunt_detail_screen.dart.
        - Set up navigation so tapping a card takes the user to the full description and "Start Hunt" button.

Phase 3: Authentication & Identity
Goal: Secure the application and provide personalized user experiences.

    [x] Step 3.1: Firebase Authentication Service
        - Implement AuthService with at least two providers (Email/Password AND Google Sign-In).
        - Include password reset logic.

    [x] Step 3.2: Auth UI & The Auth Gate
        - Create LoginScreen and RegistrationScreen.
        - Create an AuthGate widget that listens to the Firebase Auth state stream.
        - If user == null, show LoginScreen. Else, show the Discovery Screen.

Phase 4: GPS Service & Hunt Creation
Goal: Implement the core GPS features allowing users to create and participate in geo-specific hunts.

    [x] Step 4.1: Maps Integration
        - Integrate Google Maps for selecting target locations during creation and visual guidance during the hunt.
        - Implement Geofencing to automatically trigger "Correct!" when a user enters the designated area.

    [x] Step 4.2: Advanced Permissions
        - Request foreground and background location access with proper UX handling.

    [x] Step 4.3: Hunt Creation Flow
        - Implement the UI and logic for users to create their own hunts, including setting coordinates and riddles.

    [x] Step 4.4: Enhanced UX & Safety
        - Implement Clue/Hint System and Media Support (images/audio).
        - Add a Report Button for moderation and Privacy Zones to restrict hunt locations.

Phase 5: Polish & Persistence 

    [x] Step 5.1: Local State (Shared Preferences) 
        - Implement local persistence (e.g., Dark Mode toggle or "Don't show this again" intro screen). 

    [x] Step 5.2: Error Handling & Loading States 
        - Ensure all asynchronous Riverpod providers correctly handle loading and error states in the UI. 

    [x] Step 5.3: Final Theming & Cleanup 
        - Apply consistent padding, colors, and typography. 
        - Refactor any files that have grown too large (> 200 lines) by extracting widgets.
    
    [x] Step 5.4: Bug Fixes
        - The display settings (i.e. dark or light mode) activates after the second activation of the button, then it works perfectly fine.  Please fix it so that the button activates upon the first button press.

Phase 6: New Features and Bug Fixes

    [x] Step 6.1: Toggleable distance
        - Create a toggle in the hunt create screen that decides whether the user's exact distance will be shown during the hunt
        - When enabled, the exact distance will be shown, when disabled, it only tells you if you're close at certain distances
    
    [x] Step 6.2: Different Homepages
        - Create two discovery screens for the app; One where the hunts are listed as "Distance shown" and the other where it is more riddle-like, and the user will not know their exact distance
        - Hunts with distance shown should only appear in the "Distance Shown" feed, and the other discovery page should have the "Riddle" hunts where you do not know your distance.

    [x] Step 6.3: Different Theming
        - The dark mode theming is hard to see currently as it is dark blue on a black background.
        - Please change the dark blue to something more visible for ONLY the dark mode in the app
        - Also change the "Riddle Mode" and "Distance Shown" homepag tab colors so that it is visible in light mode.  Currently, brown on dark blue is bad enough, but when the tab is selected, the button turns dark blue making it invisible in light mode.