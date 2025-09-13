import 'dart:async';

import 'package:flutter/material.dart';
// ...existing code...

// This class holds all the translated text for the application.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the boilerplate code in one place.
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Map of language codes to their translated strings.
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Student Risk Tracker',
      'dashboard': 'Dashboard',
      'students': 'Students',
      'highRisk': 'High Risk',
      'mediumRisk': 'Medium Risk',
      'lowRisk': 'Low Risk',
      'all': 'All',
      'addStudent': 'Add Student',
      'editStudent': 'Edit Student',
      'studentName': 'Student Name',
      'attendance': 'Attendance (%)',
      'marks': 'Marks (%)',
      'feesPaid': 'Fees Paid',
      'guardianPhone': 'Guardian Phone',
      'save': 'Save',
      'delete': 'Delete',
      'callGuardian': 'Call Guardian',
      'settings': 'Settings',
      'language': 'Language',
      'riskThresholds': 'Risk Thresholds',
      'highRiskThreshold': 'High Risk starts at',
      'mediumRiskThreshold': 'Medium Risk starts at',
      'nameRequired': 'Name is required',
      'phoneRequired': 'Phone number is required',
      'phoneInvalid': 'Enter a valid 10-digit phone number',
      'attendanceRequired': 'Attendance is required',
      'marksRequired': 'Marks are required',
      'noStudentsFound': 'No students found. Tap the + button to add one!',
      'confirmDeleteTitle': 'Confirm Delete',
      'confirmDeleteContent': 'Are you sure you want to delete this student?',
      'cancel': 'Cancel',
    },
    'hi': {
      'appTitle': 'छात्र जोखिम ट्रैकर',
      'dashboard': 'डैशबोर्ड',
      'students': 'छात्र',
      'highRisk': 'उच्च जोखिम',
      'mediumRisk': 'मध्यम जोखिम',
      'lowRisk': 'कम जोखिम',
      'all': 'सभी',
      'addStudent': 'छात्र जोड़ें',
      'editStudent': 'छात्र संपादित करें',
      'studentName': 'छात्र का नाम',
      'attendance': 'उपस्थिति (%)',
      'marks': 'अंक (%)',
      'feesPaid': 'फीस का भुगतान',
      'guardianPhone': 'अभिभावक का फ़ोन',
      'save': 'सहेजें',
      'delete': 'हटाएं',
      'callGuardian': 'अभिभावक को कॉल करें',
      'settings': 'सेटिंग्स',
      'language': 'भाषा',
      'riskThresholds': 'जोखिम थ्रेसहोल्ड',
      'highRiskThreshold': 'उच्च जोखिम यहां से शुरू होता है',
      'mediumRiskThreshold': 'मध्यम जोखिम यहां से शुरू होता है',
      'nameRequired': 'नाम आवश्यक है',
      'phoneRequired': 'फ़ोन नंबर आवश्यक है',
      'phoneInvalid': 'एक वैध 10-अंकीय फ़ोन नंबर दर्ज करें',
      'attendanceRequired': 'उपस्थिति आवश्यक है',
      'marksRequired': 'अंक आवश्यक हैं',
      'noStudentsFound': 'कोई छात्र नहीं मिला। एक जोड़ने के लिए + बटन टैप करें!',
      'confirmDeleteTitle': 'हटाने की पुष्टि करें',
      'confirmDeleteContent': 'क्या आप वाकई इस छात्र को हटाना चाहते हैं?',
      'cancel': 'रद्द करें',
    },
    'mr': {
      'dashboard': 'डॅशबोर्ड',
      'addStudent': 'विद्यार्थी जोडा',
      'editStudent': 'विद्यार्थी संपादित करा',
      'settings': 'सेटिंग्ज',
      'studentName': ' विद्यार्थ्याचे नाव',
      'guardianPhone': 'पालकांचा फोन',
      'attendance': 'उपस्थिती (%)',
      'marks': 'गुण (%)',
      'feesPaid': 'फी भरली',
      'save': 'जतन करा',
      'delete': 'हटवा',
      'cancel': 'रद्द करा',
      'confirmDeleteTitle': 'हटवण्याची पुष्टी करा',
      'confirmDeleteContent': 'तुम्हाला खात्री आहे की तुम्ही हा विद्यार्थी हटवू इच्छिता?',
      'nameRequired': 'नाव आवश्यक आहे',
      'phoneRequired': 'फोन नंबर आवश्यक आहे',
      'phoneInvalid': 'वैध 10-अंकी फोन नंबर प्रविष्ट करा',
      'attendanceRequired': 'उपस्थिती आवश्यक आहे',
      'marksRequired': 'गुण आवश्यक आहेत',
      'noStudentsFound': 'कोणतेही विद्यार्थी आढळले नाहीत.\nसुरू करण्यासाठी एक जोडा.',
      'callGuardian': 'पालकांना कॉल करा',
      'all': 'सर्व',
      'highRisk': 'उच्च धोका',
      'mediumRisk': 'मध्यम धोका',
      'lowRisk': 'कमी धोका',
      'riskThresholds': 'धोका पातळी',
      'riskThresholdsDescription': 'जेव्हा विद्यार्थ्याचा धोका गुण या मूल्यांपेक्षा जास्त असेल तेव्हा श्रेणी सेट करा.',
      'highRiskThresholdLabel': 'उच्च धोका पातळी (उदा. 60)',
      'mediumRiskThresholdLabel': 'मध्यम धोका पातळी (उदा. 30)',
      'valueRequired': 'मूल्य आवश्यक आहे',
      'highRiskThresholdValidation': 'उच्च धोका पातळी मध्यमपेक्षा जास्त असणे आवश्यक आहे.',
      'settingsSaved': 'सेटिंग्ज जतन केल्या!',
    },
  };

  // Getters for each translated string.
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  // ... Add getters for all other keys here for convenience
  String text(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

// The LocalizationsDelegate is responsible for loading the correct language.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

