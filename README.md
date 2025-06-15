Platform Design

Authorization
The Authorization page appears upon first launch or after a user logs out. It offers options to sign in or register using Firebase Authentication, with a Google Sign‑In button for streamlined access. Users can log in through their Google email account, and successful authentication transitions users to the Welcome page. All authentication tokens are securely stored in the client’s key chain (iOS) or encrypted shared preferences (Android) to maintain session state across app restarts.

Welcome Page
The Welcome page serves as the app’s landing screen for authenticated users who sign into the app for the first time. It features a brief scanning workflow that takes the user’s basic data and stores it in the database. A central “Continue” button guides users to the Home page. The design employs a clean layout with illustrative pictures and concise text.

Home Page
Also referred to as the Diary page, the Home page allows users to capture and review food entries. Daily nutrition details are summed up and are displayed at the top below the date of the page. Below this, three scrollable lists display the meals logged, with each section having its own “add” button. The add button opens up the camera and gives access to the gallery. Users are also able to swipe to delete the meals logged under each category of breakfast, lunch, and dinner. 

Report Page
The report page lets users choose up to seven consecutive days to generate a report for. Users are then able to visualize AI’s analysis of their daily intake of nutrients based on their personal information. An overall score would be given to the user, along with a comment from AI on their diet. All thirty nutrients are displayed in the report; deficiencies below 80% and over 120% are highlighted in red, while those within the range are highlighted in green. The report will be available to be download as an image to the user’s phone.

Chat Page
The Chat page hosts the GPT‑4o‑powered chatbot, presented as a conversational interface. Previous messages appear in a vertically scrollable view, with user queries and bot responses to be viewed by their profile picture. The input field at the bottom supports text entry. The assistant takes information for the past week of the user’s logs and the user’s personal information.

Settings Page
The Settings page allows users to manage their personal health data and account settings. At the top, the user’s profile picture and display name, retrieved from their Google account via Firebase Authentication, are prominently displayed, offering a sense of personalization. Below this, editable fields allow users to input or update their current weight, goal weight, height, and birthdate. These metrics are used by the app to tailor nutrient targets, report and chatbot feedback. The logout function is located at the bottom of the page, accompanied by the user’s authenticated email address for clarity. When selected, it signs the user out securely and clears session tokens from the device.

Dark Mode
To accommodate user preferences and reduce eye strain, the app detects system‑level colour scheme settings and automatically switches between light and dark themes. All UI components, including backgrounds, text, icons, and charts, adjust their colour palettes to maintain contrast and readability.
