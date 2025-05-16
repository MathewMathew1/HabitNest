import 'package:flutter/material.dart';
import 'package:habitata_app/models/habitsRepository/habitsRepository.dart';
import '../models/habit.dart';

class CreateHabitDialog extends StatefulWidget {
  final List<Habit> existingHabits;
  final void Function(Habit habit) onHabitCreated;

  const CreateHabitDialog({
    super.key,
    required this.existingHabits,
    required this.onHabitCreated,
  });

  @override
  State<CreateHabitDialog> createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<CreateHabitDialog> {
  final _nameController = TextEditingController();
  final _emojiController = TextEditingController();
  bool _isPositive = true;
  String? _errorMessage;
  final _repo = CustomHabitsRepository();

  void _submit() async {
    final name = _nameController.text.trim();
    final emoji = _emojiController.text.trim();

    final existsInSample = widget.existingHabits.any(
      (h) => h.name.toLowerCase() == name.toLowerCase(),
    );

    final existsInCustom = await _repo.nameExists(name);

    if (emoji.length > 1) {
      _showError('Emoji can have only one character.');
      return;
    }

    if (name.isEmpty || emoji.isEmpty) {
      _showError('Name and emoji are required.');
      return;
    }

    if (existsInSample || existsInCustom) {
      _showError('A habit with this name already exists.');
      return;
    }

    final newHabit = Habit(
      name: name,
      emoji: emoji,
      isPositiveHabit: _isPositive,
    );

    await _repo.addCustomHabit(newHabit);
    widget.onHabitCreated(newHabit);
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Custom Habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Habit Name'),
          ),
          TextField(
            controller: _emojiController,
            decoration: const InputDecoration(labelText: 'Emoji'),
          ),
          Row(
            children: [
              const Text('Good habit?'),
              Switch(
                value: _isPositive,
                onChanged: (val) => setState(() => _isPositive = val),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}
