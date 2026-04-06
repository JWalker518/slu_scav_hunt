# Prompts
## Prompts given to Gemini CLI

### March 4th
* Gemini, please read the AI Assistant Guardrails located in requirements.md and please familiarize yourself with them. Do not read further than that.

* Please enact step 1.1 of Phase 1

* Can you read the about.md file in the about folder and summarize to me the key take aways you've gotten from it, along with what you think it may need for an app

* Please continue with Phase 1, step 1.2 please

### March 9th
* Please familiarize yourself with requirements.md located in the about folder. Do not execute any code

* Can you list the various requirements a 'blog page' would require, where users can find hunts to participate in? Please list them like how the steps are in requirements.md.

* Familiarize yourself with requirements.md now that changes have been made. Does anything look out of place, as in does any certain step seem redundant and or useless?

* Do not make changes to any file yet, but please list the changes you would make to requirements.md

### March 11th
* Please continue to Step 2.1 in requirements.md, while adhering to the AI guidelines and the step information itself.

* Yes, please proceed to step 2.2

* I have recently added firebase to this project, please familiarizeyourself with the new changes

* Please continue to step 2.3

* Please familiarize yourself with the code again

* Continue to step 2.4

* Since riverpod has updated, make sure all previous instances of riverpod are updated to the current version as to not introduce unwanted bugs

* Proceed to step 2.5

* Line 11 in discovery_screen.dart seems to be catching an error currently, could you piece together what this error could be about?

* The app still freezes when loading in.  It gets stuck on the spinning wheel icon and VSCode highlights line 11 in discovery_screen.dart "final huntsAsync = ref.watch(huntsProvider);"  Please discuss what the issue may be here.


### March 18th
* Please continue to step 2.6

* Please proceed to step 2.7

* Realistically, we wouldn't want to show the coordinates on the hunt card screen since we want the user to have to find those coordinates themselves.  Please adjust the hunt detail screen so that the coordinates aren't visible to the user who may want to start that hunt.

* The test we created for when the loading froze due to the firebase connection appears to be causing the app to buffer every ten seconds. Can you please remove that test as we no longer need it so that our page doesn't buffers? 

* I think we're ready. Time to begin Phase 3... Please proceed with step 3.1.

### March 31st
* Please update any necessary files with up to date code

### April 5th
* Please update any necessary files with up to date code

* Currently, we have the ability to log-in, but what if I'd like to log in as another user?  Could you please add for the ability to log out of the software?
 
* The log-out function does not log the user out currently. On top of that, the 'sign in with Google' button does not prompt the user to do anything regarding a google sign-in. Please asses any changes that may need to be made to fix this.

* First, the 'sign in with google' option returns the error message "failed to sign in with google', and secondly, trying to log out using the log out button prompts the app to freeze.

* The issues with logging out and signing in with google still exist, but we can fix them after establishing the app's functionability.  So, please begin Phase 4 step 4.1.

* Where would I find this api key

* What should I input as my restriction type, and my SHA-1 finger certificate

* What if I just choose website instead for my restriction type

* Please check each of my files in slu_scav_hunt folder for any api keys, and make sure those files are in the .gitignore file so that they will not be committed and pushed

* I've enabled my api by choosing the API restriction option and then choosing the APIs' Maps SDK for Android and Maps SDK for IOS, so how should I proceed with previewing my APIs

* Selecting the "Start Hunt" button works, and the app asks for my location, but once I select 'allow' I am brought to an error screen stating "TypeError: Cannot read properties of undefined (reading 'MapTypeid') See also: https://docs.flutter.dev/testing/errors"

* Please remember to git commit and push with a descriptive comment before making any changes to the code
