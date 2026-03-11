# Hunt
## Problem
I want a unique experience where people can work together to solve a series of problems/riddles that a user created in an ARG (Alternate Reality Game).  I want the users to be able to leave a riddle, and for other users to be able to solve the puzzle and be rewarded.

## Solution
The solution? A campus wide scavenger hunt that uses the app to track progress.  There will be a homepage where users can participate in other users’ hunts where the goal is to reach a certain location as described in the puzzle.  GPS will be used to mark when a user has completed another user’s hunt.  Users will be able to like others’ hunts after they complete them.  Users can either create hunts for others, participate in hunts, or do both if they’d like.

## Key Features:
•	A home page containing hunts left by other users.  Each hunt will be able to be clicked on leading to another page where users can read a puzzle that will guide them to a location.
•	GPS tracking to mark when a user has completed a hunt.  When a user reaches the marked location, it will tell them that they are correct or something along those lines.
•	Users can ‘like’ a hunt they’ve completed which will show on the hunts page.  A popular page will show the most popular hunts.
•	A User page where you can track which hunts you’ve a) participated in, and b) which hunts you’ve created.
•	A hunt creation page where a user can write the puzzle for their hunt, and choose on a map where they want their hunt to lead.

## Gemini's Approach
 Key Takeaways
   - User-Generated Content: Users can create scavenger hunts involving puzzles
     or riddles that lead to specific physical locations.
   - GPS-Based Completion: The app uses GPS to verify when a participant has
     reached the correct destination described in the puzzle.
   - Social Integration: A "like" system for completed hunts and a "popular"
     page to highlight top-rated hunts.
   - Personal Tracking: A user profile to track both created and completed
     hunts.
   - Creation Workflow: A dedicated interface for writing riddles and selecting
     a target location on a map.


  App Requirements & Recommendations
  To build this successfully, the app will likely need:
   1. Maps Integration:
      - Google Maps (or similar): For selecting target locations during creation
        and providing a visual guide (if allowed) during the hunt.
      - Geofencing: To automatically trigger "Correct!" when a user enters the
        designated area.
   2. Real-time Data:
      - Cloud Firestore: To store hunt details (riddle, coordinates, like
        counts) and user progress instantly.
   3. Advanced Permissions:
      - Location Services: Requesting foreground and potentially background
        location access (depending on UX).
   4. Enhanced UX Features:
      - Clue/Hint System: A way for creators to provide optional hints if a user
        is stuck.
      - Media Support: Allowing creators to attach images or audio clips as part
        of the riddle.
      - Leaderboards: A global or hunt-specific leaderboard to foster
        competition.
   5. Safety & Moderation:
      - Report Button: To handle inappropriate content in user-generated
        riddles.
      - Privacy Zones: To prevent users from creating hunts in restricted or
  Would you like to proceed with Step 1.2 or focus on one of these specific
  areas?

