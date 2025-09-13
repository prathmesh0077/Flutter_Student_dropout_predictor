Flutter Student Dropout Risk Tracker

A simple, offline-first Flutter application designed for rural school teachers in India to track student data and identify potential dropouts based on a configurable risk score. The app is bilingual (English/Hindi), lightweight, and optimized for low-end Android devices.
Features

    Offline-First: All data is stored locally on the device using Hive. The app works fully without an internet connection.

    Bilingual Support: Easily switch between English and Hindi.

    Risk Calculation: Automatically calculates a risk score for each student based on attendance, marks, and fee payment status.

    Dashboard Overview: A clean dashboard with a pie chart showing the distribution of students across risk categories (High, Medium, Low).

    Student Management: Add, edit, and delete student records through a simple form.

    Guardian Communication: Tap-to-call a student's guardian directly from the app.

    Customizable Settings: Teachers can adjust the thresholds for risk categories to better suit their school's needs.

Getting Started
Prerequisites

    Flutter SDK installed on your machine.

    An Android emulator or a physical Android device (API 21+).

    A code editor like VS Code or Android Studio.

Setup Instructions

    Clone the repository:

    git clone <repository-url>
    cd student_tracker_app

    Install dependencies:
    Run this command in your terminal from the project's root directory:

    flutter pub get

    Run the code generator:
    The app uses Hive, which requires generated "adapter" files to work. Run the following command. This only needs to be done once, or whenever you change the student_model.dart file.

    flutter pub run build_runner build --delete-conflicting-outputs

    Run the app:
    Make sure your emulator is running or a device is connected, then run:

    flutter run

How the Risk Formula Works

The risk score is calculated to provide a quick, at-a-glance indicator of a student's potential for dropping out. The score is a weighted average of three factors:

    Attendance Risk (50% weight): 100 - attendance %

        Lower attendance results in a higher risk score.

    Marks Risk (35% weight): 100 - marks %

        Lower marks contribute significantly to the risk score.

    Fees Risk (15% weight): 0 if fees are paid, 100 if not

        Unpaid fees are a flag for potential financial hardship.

Final Formula:
riskScore = (0.50 * attendanceRisk) + (0.35 * marksRisk) + (0.15 * feesRisk)

The score is then categorized:

    High Risk: score ≥ 60 (Default)

    Medium Risk: 30 ≤ score < 60 (Default)

    Low Risk: score < 30 (Default)

Note: These threshold values can be changed on the Settings page within the app.
How to Add/Modify Translations

The app's text is managed in one central file, making it easy to add more languages or change existing text.

    Open the localization file:
    Navigate to lib/utils/app_localizations.dart.

    Find the _localizedValues map:
    This map holds all the text for the app. It has keys for each language code (e.g., 'en' for English, 'hi' for Hindi).

    static final Map<String, Map<String, String>> _localizedValues = {
      'en': {
        'dashboard': 'Dashboard',
        'addStudent': 'Add Student',
        // ... more english text
      },
      'hi': {
        'dashboard': 'tableau de bord', // Hindi translation
        'addStudent': 'छात्र जोड़ें', // Hindi translation
        // ... more hindi text
      },
    };

    To change text: Find the key (e.g., 'dashboard') and change its value for the desired language.

    To add a new language:

        Add a new entry to the _localizedValues map with a new language code (e.g., 'mr' for Marathi).

        Copy all the keys from the 'en' map and provide their translations.

        Go to lib/main.dart and add the new Locale to the supportedLocales list:

        supportedLocales: const [
          Locale('en', ''),
          Locale('hi', ''),
          Locale('mr', ''), // Add new locale here
        ],

