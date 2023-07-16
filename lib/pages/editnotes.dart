// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:sqflite_package/pages/home_page.dart';
import 'package:sqflite_package/pages/sql_db.dart';

class EditNotes extends StatefulWidget {
  final note;
  final title;
  final date;
  final id;
  const EditNotes({super.key, this.note, this.title, this.id, this.date});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  SqlDb sqlDb = SqlDb();

  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();

  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    date.text = widget.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellow,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Notes",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: formstate,
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Note",
                    ),
                    controller: note,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: "date",
                    ),
                    controller: date,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    child: const Text(
                      "Edit Notes",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () async {
                      int response = await sqlDb.update(
                          "notes",
                          {
                            'note': note.text,
                            'title': title.text,
                            'date': date.text,
                          },
                          "id = ${widget.id} ");
                      if (response > 0) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            (route) => false);
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
