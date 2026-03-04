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

 
  
## Implementation Roadmap 
Phase 1: Project Setup & Core Infrastructure 
    Step 1.1: Dependencies & Theme 
    -	Add Riverpod, Firebase Core, Firebase Auth, Cloud Firestore (or Postgres driver), and Shared Preferences to pubspec.yaml. 
    -	Create a centralized ThemeData class in lib/theme.dart (colors, typography). 
    Step 1.2: Base Architecture 
    -	Set up the folder structure (models, screens, widgets, services, providers). 
    -	Wrap MyApp in a ProviderScope. 

Phase 2: Milestone 1 - The "Minimum Viable Product" (MVP) 
Goal: The core defining feature of the app must function with mock data or local state. Note: Focus on functionality, not perfect styling yet. 
    Step 2.1: [describe one requirement] 
    Step 2.2: [describe one requirement] 
    Step 2.3: and so on 
 
Phase 3: Milestone 2 - App Functionality and Integration (Auth & Database) 
Goal: Complete major functionality and replace mock data with live cloud and authentication. 
    Step 3.1: Firebase Authentication 
    -	Implement AuthService with at least two providers (e.g., Email/Password AND Google 
        Sign-In). 
    -	Create a LoginScreen and a RegistrationScreen. 
    Step 3.2: The Auth Gate 
    -	Create an AuthGate widget that listens to the Firebase Auth state stream. 
    -	If user == null, show LoginScreen. Else, show MVP screen. 
    Step 3.3: Cloud Database Integration 
    -	Replace the mock service with a real DatabaseService. 
    -	Implement CRUD (Create, Read, Update, Delete) operations for the core models. 
    -	Update Riverpod providers to listen to database streams or fetch live data. 
    Phase 4: Polish & Persistence 
    Step 4.1: Local State (Shared Preferences) 
    -	Implement a feature that saves to the local device (e.g., a "Dark Mode" toggle or a "Don't show this again" intro screen). 
    Step 4.2: Error Handling & Loading States 
    -	Ensure all asynchronous Riverpod providers correctly handle loading and error states in the UI using AsyncValue.when(). 
    Step 4.3: Final Theming & Cleanup 
    -	Apply consistent padding, colors, and typography. 
    -	Refactor any files that have grown too large (> 200 lines) by extracting widgets. 
