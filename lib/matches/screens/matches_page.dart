import 'package:eplradar_mobile/widgets/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:eplradar_mobile/matches/screens/show_matches_list.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  int _selectedWeek = 7;
  List<int> _availableWeeks = List.generate(10, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: RightDrawer(),
      backgroundColor: const Color(0xFF1D1F22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F22),
        elevation: 0,
        title: const Text(
          'Semua Match Musim Ini',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Week Filter Dropdown
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2E33),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedWeek,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF2C2E33),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  items: _availableWeeks.map((week) {
                    return DropdownMenuItem<int>(
                      value: week,
                      child: Text('Pekan ke-$week'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedWeek = value;
                      });
                    }
                  },
                ),
              ),
            ),
          ),

          // Matches List
          Expanded(
            child: ShowMatchesList(selectedWeek: _selectedWeek),
          ),
        ],
      ),
    );
  }
}
