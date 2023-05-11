import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Widgets/cardWidget.dart';


class PresentationPlanner extends StatefulWidget {
  const PresentationPlanner({Key? key}) : super(key: key);

  @override
  _PresentationPlannerState createState() => _PresentationPlannerState();
}

class _PresentationPlannerState extends State<PresentationPlanner> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<CardWidget> _presentationCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Präsentationsplaner'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Präsentationstitel',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
              ),
            ),
          ),
          ListTile(
            title: Text('Datum: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
          ListTile(
            title: Text('Uhrzeit: ${_selectedTime.format(context)}'),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (pickedTime != null && pickedTime != _selectedTime) {
                setState(() {
                  _selectedTime = pickedTime;
                });
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _presentationCards.add(
                    CardWidget(
                      title: _titleController.text,
                      subtitle: _subtitleController.text,
                      icon: Icons.add,
                      route: const Placeholder(),
                      date: DateFormat('dd.MM.yyyy').format(_selectedDate),
                      time: _selectedTime.format(context),
                    ),
                  );
                  _titleController.clear();
                  _subtitleController.clear();
                });
              },
              child: const Text('Präsentation hinzufügen'),
            ),
          ),
          ..._presentationCards,
        ],
      ),
    );
  }
}
