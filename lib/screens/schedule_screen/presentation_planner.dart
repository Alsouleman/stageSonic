import 'dart:async';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stagesonic_video/Widgets/BoxShadow_widget.dart';


class PresentationPlanner extends StatefulWidget {
  const PresentationPlanner({Key? key}) : super(key: key);

  @override
  _PresentationPlannerState createState() => _PresentationPlannerState();
}

class _PresentationPlannerState extends State<PresentationPlanner> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final _database = FirebaseDatabase.instance.ref();
  Map<String , bool> _showDescription = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[350],
        title: const Text(
          'Presentation Planner',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:FirebaseAnimatedList(
        query: _database.child('presentations'),
        itemBuilder: (ctx, snapshot, animation, index) {
          String key = snapshot.key!; // Get the key for this presentation
          _showDescription.putIfAbsent(key, () => false); // Initialize if not already present

          DateTime date = DateFormat("dd.MM.yyyy").parse(snapshot.child('date').value.toString());
          return Column(
              children: [
                const SizedBox(height: 40,),
                BoxShadowWidget(
                  boxRadius: 5,
                  height:_showDescription[key] ?? false ? 250 : 170,
                  width: MediaQuery.of(context).size.width / 1.2,
                  onClicked: () {},
                  backgroundColor: Colors.grey[300]!,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 5 ,bottom: 5),
                         child: Text('${timeago.format(date)} ',
                           style: const TextStyle(fontSize: 15 ),),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 150),
                         child: IconButton(
                             onPressed: () {_deletePresentation(key);},
                             icon: const Icon(Icons.delete)),
                       )
                     ],),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('Title: ${snapshot.child('title').value.toString()}',
                          style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5 , top: 10),
                        child: Text('Date: ${snapshot.child('date').value.toString()}',
                          style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5 , top: 10),
                        child: Text('Time: ${snapshot.child('time').value.toString()}',
                          style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showDescription[key] = !_showDescription[key]!;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'more details..',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_showDescription[key]! )
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Description:  ${snapshot.child('description').value.toString()}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ]
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BoxShadowWidget(
            height: 50,
            width: 50,
            onClicked: () {},
            backgroundColor: Colors.grey[200]!,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[200]!,
              onPressed: _showAddPresentationSheet,
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _deletePresentation(String key) {
    _database.child('presentations').child(key).remove();
  }
  void _addPresentation() {
    String? key = _database.child('presentations').push().key;
    if (key != null) {
      _database.child('presentations').child(key).set({
        'title': _titleController.text,
        'description': _subtitleController.text,
        'date': DateFormat('dd.MM.yyyy').format(_selectedDate),
        'time': _selectedTime.format(context),
      });
    }

    _titleController.clear();
    _subtitleController.clear();
  }

  TextField buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  void _showAddPresentationSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTextField('Title', _titleController),
                  buildTextField('Description', _subtitleController),
                  ListTile(
                    title: Text(
                        'Datum: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _pickDate,
                  ),
                  ListTile(
                    title: Text('Uhrzeit: ${_selectedTime.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: _pickTime,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _addPresentation();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Präsentation hinzufügen'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
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
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
}
