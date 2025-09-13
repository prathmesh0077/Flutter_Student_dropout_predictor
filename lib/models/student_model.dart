import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// This line is essential for the Hive code generator.
// It tells the generator that this file needs a 'part' file to be generated.
part 'student_model.g.dart';

// HiveType IDs should be unique across your entire application.
@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double attendance; // Stored as a percentage, e.g., 95.5

  @HiveField(2)
  double marks; // Stored as a percentage, e.g., 88.0

  @HiveField(3)
  bool feesPaid;

  @HiveField(4)
  String guardianPhone;

  @HiveField(5)
  DateTime lastUpdated;
  
  @HiveField(6)
  List<WeeklySnapshot> weeklySnapshots;

  Student({
    required this.name,
    required this.attendance,
    required this.marks,
    required this.feesPaid,
    required this.guardianPhone,
    required this.lastUpdated,
    this.weeklySnapshots = const [],
  });

  // --- Risk Calculation Logic ---
  // This is the core formula to predict dropout risk.
  // It's placed inside the model for easy access and modification.

  double get riskScore {
    // 1. Calculate individual risk components (0-100 scale)
    final double attendanceRisk = 100.0 - attendance;
    final double marksRisk = 100.0 - marks;
    final double feesRisk = feesPaid ? 0.0 : 100.0;

    // 2. Apply weights to each component and sum them up.
    // These weights can be adjusted in the settings.
    // Default: Attendance is 50%, Marks 35%, Fees 15%
    final double score = (0.50 * attendanceRisk) + (0.35 * marksRisk) + (0.15 * feesRisk);
    
    // Ensure score is within 0-100 range.
    return score.clamp(0.0, 100.0);
  }

  RiskCategory get riskCategory {
    final score = riskScore;
    // These thresholds (60 and 30) will be configurable from the settings screen.
    if (score >= 60) {
      return RiskCategory.High;
    } else if (score >= 30) {
      return RiskCategory.Medium;
    } else {
      return RiskCategory.Low;
    }
  }
}


@HiveType(typeId: 1)
class WeeklySnapshot {
  @HiveField(0)
  double attendance;
  
  @HiveField(1)
  double marks;

  @HiveField(2)
  bool feesPaid;

  @HiveField(3)
  DateTime weekDate;

  WeeklySnapshot({
    required this.attendance,
    required this.marks,
    required this.feesPaid,
    required this.weekDate,
  });
}


// Enum to represent the risk categories. Using an enum makes the code
// cleaner and less prone to errors than using simple strings.
@HiveType(typeId: 2)
enum RiskCategory {
  @HiveField(0)
  High,
  @HiveField(1)
  Medium,
  @HiveField(2)
  Low
}

// Helper extension to get the color associated with each risk category.
// This keeps the UI logic separate from the data model.
extension RiskCategoryExtension on RiskCategory {
  Color get color {
    switch (this) {
      case RiskCategory.High:
        return Colors.red[700]!; // Deep Red
      case RiskCategory.Medium:
        return Colors.amber[700]!; // Strong Amber
      case RiskCategory.Low:
        return Colors.green[700]!; // Dark Green
      // ignore: unreachable_switch_default
      default:
        return Colors.grey;
    }
  }

  String toLocalizedString(BuildContext context) {
    // This will be used later for showing "High", "Medium", "Low" in Hindi/English.
    // For now, we'll just return the English name.
     switch (this) {
      case RiskCategory.High:
        return 'High Risk';
      case RiskCategory.Medium:
        return 'Medium Risk';
      case RiskCategory.Low:
        return 'Low Risk';
    }
  }
}

