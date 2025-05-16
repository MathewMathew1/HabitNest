import 'package:flutter/material.dart';
import 'package:habitata_app/models/filter_type.dart';
import 'package:habitata_app/models/habit.dart';
import 'package:habitata_app/models/habitsRepository/habitsRepository.dart';
import 'package:habitata_app/models/userHabitRepository/localJsonHabitRepository.dart';
import 'package:habitata_app/widgets/create_custom_habit.dart';
import 'package:habitata_app/widgets/user_habits_view.dart';
import 'package:provider/provider.dart';
import '../data/sample_habits.dart';
import '../widgets/habit_list.dart';

class DailyRoutineScreen extends StatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  State<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
  final TextEditingController _controller = TextEditingController();
  String _inputValue = '';
  HabitFilterType _filterType = HabitFilterType.all;
  late LocalHabitsRepository dataHandler;
  late UserHabits _userHabits;
  final _customRepo = CustomHabitsRepository();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    dataHandler = Provider.of<LocalHabitsRepository>(context, listen: false);
    _userHabits = UserHabits(dataHandler: dataHandler);
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    await _userHabits.fetchData();
    final customHabits = await _customRepo.loadCustomHabits();
    setState(() {
      sampleHabits.addAll(customHabits);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasHabits =
        _userHabits.goodHabits.isNotEmpty || _userHabits.badHabits.isNotEmpty;

    Future<void> saveData() async {
      await _userHabits.saveData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Habits saved!')));
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Routine')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      child: TextField(
                        controller: _controller,
                        onChanged: (text) {
                          setState(() {
                            _inputValue = text;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for habit',
                          labelText: 'Habit',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<HabitFilterType>(
                        value: _filterType,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _filterType = value;
                            });
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: HabitFilterType.all,
                            child: Row(
                              children: [
                                Icon(Icons.all_inclusive),
                                SizedBox(width: 8),
                                Text('All'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: HabitFilterType.good,
                            child: Row(
                              children: [
                                Icon(Icons.thumb_up, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Good'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: HabitFilterType.bad,
                            child: Row(
                              children: [
                                Icon(Icons.thumb_down, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Bad'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => CreateHabitDialog(
                          existingHabits: sampleHabits,
                          onHabitCreated: (habit) {
                            setState(() {
                              _userHabits.addHabit(habit);
                            });
                          },
                        ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Create Custom Habit"),
              ),
              HabitList(
                habits: sampleHabits,
                goodHabits: _userHabits.goodHabits,
                badHabits: _userHabits.badHabits,
                searchQuery: _inputValue,
                filterType: _filterType,
                onHabitTap: (habit) {
                  setState(() {
                    _userHabits.addHabit(habit);
                  });
                },
              ),
              UserHabitsView(
                userHabits: _userHabits,
                onRemove: (name, isBad) {
                  setState(() {
                    _userHabits.removeHabitByName(name, isBad);
                  });
                },
                onChangeIntensity: (name, isBad, newIntensity) {
                  setState(() {
                    _userHabits.changeIntensity(newIntensity, name, isBad);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          hasHabits
              ? Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: saveData,
                    child: const Text('Save Daily Routine'),
                  ),
                ),
              )
              : null,
    );
  }
}
