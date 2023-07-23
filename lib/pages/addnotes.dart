import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_package/pages/home_page.dart';
import 'package:sqflite_package/pages/sql_db.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:audioplayers/audioplayers.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final SqlDb sqlDb = SqlDb();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  AudioCache audioCache = AudioCache(); // Nouveau - Initialisation d'AudioCache

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String noteDate = DateFormat('d MMM yyyy').format(date);
    //print(noteDate);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(noteDate),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 3,
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: "note",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a note';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                ButttonWithIcon(
                  icon: Icons.add_task,
                  title: "Add Notes",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      int response = await sqlDb.insert("notes", {
                        'note': _noteController.text,
                        'title': _titleController.text,
                        'date': noteDate,
                      });

                      if (response > 0) {
                        //*Play audio
                        final player = AudioPlayer();
                        player.play(AssetSource('audio/shortsuccesaudio.mp3'));
                        setState(() {});

                        await AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.scale,
                          title: 'Succesful',
                          desc: 'La note est bien ajoutée',
                          autoHide: const Duration(seconds: 2),
                          onDismissCallback: (type) {
                            debugPrint('Dialog Dismiss from callback $type');
                          },
                        ).show();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
