import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart'; // To access the _changeLanguage method
import '../models/student_model.dart';
import '../utils/app_localizations.dart';
import 'add_edit_student_screen.dart';
import 'settings_screen.dart';


// The rest of the file (class DashboardScreen extends...) starts here



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // This state variable keeps track of which filter is currently active.
  RiskCategory? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    // A helper to easily access translated strings.
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.text('dashboard')),
        actions: [
          // Settings Button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            },
          ),
          // Language Toggle Button
          PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              MyApp.of(context).changeLanguage(locale);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('hi'),
                child: Text('हिंदी'),
              ),
            ],
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      // ValueListenableBuilder is a key Hive widget. It automatically rebuilds
      // its contents whenever the data in the 'students' box changes.
      // This makes the UI reactive and always in sync with the database.
      body: ValueListenableBuilder<Box<Student>>(
        valueListenable: Hive.box<Student>('students').listenable(),
        builder: (context, box, _) {
          final allStudents = box.values.toList().cast<Student>();

          if (allStudents.isEmpty) {
            return Center(
              child: Text(
                localizations.text('noStudentsFound'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Apply the current filter to the list of students.
          final filteredStudents = allStudents.where((student) {
            if (_selectedFilter == null) {
              return true; // Show all if no filter is selected
            }
            return student.riskCategory == _selectedFilter;
          }).toList();
          
          // Sort students by risk score, highest first.
          filteredStudents.sort((a, b) => b.riskScore.compareTo(a.riskScore));


          return Column(
            children: [
              // 1. Pie Chart Section
              _buildPieChart(context, allStudents),
              
              // 2. Filter Buttons Section
              _buildFilterButtons(context),

              const Divider(height: 1),

              // 3. Student List Section
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return _buildStudentListTile(context, student);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add/Edit screen without passing any student data.
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditStudentScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: localizations.text('addStudent'),
      ),
    );
  }

  // --- WIDGET BUILDER HELPERS ---

  Widget _buildPieChart(BuildContext context, List<Student> students) {
    // Calculate the count for each risk category.
    int highRiskCount = students.where((s) => s.riskCategory == RiskCategory.High).length;
    int mediumRiskCount = students.where((s) => s.riskCategory == RiskCategory.Medium).length;
    int lowRiskCount = students.where((s) => s.riskCategory == RiskCategory.Low).length;
    int total = students.length;

    if (total == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: highRiskCount.toDouble(),
                      color: RiskCategory.High.color,
                      title: '${(highRiskCount / total * 100).toStringAsFixed(0)}%',
                      radius: 30,
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: mediumRiskCount.toDouble(),
                      color: RiskCategory.Medium.color,
                      title: '${(mediumRiskCount / total * 100).toStringAsFixed(0)}%',
                      radius: 30,
                       titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: lowRiskCount.toDouble(),
                      color: RiskCategory.Low.color,
                      title: '${(lowRiskCount / total * 100).toStringAsFixed(0)}%',
                      radius: 30,
                       titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegend(context, RiskCategory.High, highRiskCount),
                  const SizedBox(height: 4),
                  _buildLegend(context, RiskCategory.Medium, mediumRiskCount),
                  const SizedBox(height: 4),
                  _buildLegend(context, RiskCategory.Low, lowRiskCount),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildLegend(BuildContext context, RiskCategory category, int count) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: category.color),
        const SizedBox(width: 8),
        Text('${AppLocalizations.of(context).text(category.name.toLowerCase() + 'Risk')}: $count'),
      ],
    );
  }


  Widget _buildFilterButtons(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap( 
      spacing: 8.0, // Adds space between chips on the same line
      runSpacing: 4.0, // Adds space between the lines of chips
      alignment: WrapAlignment.center, // Centers the chips
      children: [
        _buildFilterChip(context, localizations.text('all'), null),
        _buildFilterChip(context, localizations.text('highRisk'), RiskCategory.High),
        _buildFilterChip(context, localizations.text('mediumRisk'), RiskCategory.Medium),
        _buildFilterChip(context, localizations.text('lowRisk'), RiskCategory.Low),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(BuildContext context, String label, RiskCategory? category) {
     final bool isSelected = _selectedFilter == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = category;
        });
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
    );
  }

  Widget _buildStudentListTile(BuildContext context, Student student) {
    final localizations = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        // The color-coded risk badge.
        leading: CircleAvatar(
          backgroundColor: student.riskCategory.color,
          child: Text(
            student.riskScore.toStringAsFixed(0),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${localizations.text('attendance')}: ${student.attendance}% • ${localizations.text('marks')}: ${student.marks}% • ${localizations.text('feesPaid')}: ${student.feesPaid ? '✔' : '✖'}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Colors.indigo),
          tooltip: localizations.text('callGuardian'),
          onPressed: () => _callGuardian(student.guardianPhone),
        ),
        onTap: () {
          // Navigate to the Add/Edit screen, passing the specific student object.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditStudentScreen(student: student),
            ),
          );
        },
      ),
    );
  }

  // --- ACTION HANDLERS ---
  
  Future<void> _callGuardian(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        // Show an error message if the phone app can't be opened.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone app.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to make call: $e')),
        );
    }
  }
}

