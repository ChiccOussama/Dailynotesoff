import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:sqflite_package/firebase/homepage.dart';
import 'package:sqflite_package/pages/addnotes.dart';
import 'package:sqflite_package/pages/editnotes.dart';
import 'package:sqflite_package/pages/sql_db.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Déclaration de la variable sqlDb
  List<Map<String, dynamic>> filteredNotes = [];
  DateTime? selectedDate;
  SqlDb sqlDb = SqlDb();
  bool? dateclicked = false;
  bool isLoading = true;
  bool isEmpty = false;
  String? selectDate;
  bool darkMode = false;
  dynamic savedThemeMode;

  List<Map<String, dynamic>> notes =
      []; // J'ai mis à jour le type en List<Map<String, dynamic>>

  Future readData() async {
    List<Map<String, dynamic>> response = await sqlDb.read('notes');

    notes.addAll(response);
    filteredNotes =
        List<Map<String, dynamic>>.from(notes); // Ajoutez cette ligne
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabViews = [
      HomeTab(
        sqlDb: sqlDb,
        notes: notes,
      ),
      FilterListTab(
        sqlDb: sqlDb,
        notes: notes,
      ),
      AddNotesTab(),
      const AccountNote(),
    ];
    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat('EEEE').format(now);
    String month = DateFormat('MMM').format(now);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Daily Notes",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                child: Icon(Icons.home, color: Colors.black),
              ),
              Tab(
                child: Icon(Icons.filter_list, color: Colors.black),
              ),
              Tab(
                child: Icon(Icons.add_box, color: Colors.black),
              ),
              Tab(
                child: Icon(Icons.person_2_rounded, color: Colors.black),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final List<Map<String, dynamic>> notes;

  final SqlDb sqlDb;

  HomeTab({
    required this.notes,
    required this.sqlDb,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<Map<String, dynamic>> filteredNotes;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer la boîte de dialogue en appuyant à l'extérieur
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Êtes-vous sûr de vouloir supprimer toutes les données ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Ferme la boîte de dialogue et retourne à l'écran précédent
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () async {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue

                // Supprimer toutes les données
                int response = await widget.sqlDb.deleteAll("notes");
                if (response > 0) {
                  // Actualiser l'affichage après la suppression
                  widget.notes.clear();
                  filteredNotes.clear(); // Réinitialiser la liste filtrée
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    filteredNotes = widget.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            child: Text(
              "All notes : ${filteredNotes.length} notes",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return widget.notes.isEmpty
                        ? Visibility(
                            visible: true,
                            child: Column(
                              children: [
                                Lottie.asset(
                                  'assets/images/noteanimation.json',
                                  height: 360,
                                ),
                                const Text(
                                  "You do not have any tasks yet!\nAdd new tasks to make your days productive.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: TextButton(
                                  onPressed: () {
                                    showDeleteConfirmationDialog(context);
                                  },
                                  child: Row(
                                    children: const [
                                      Spacer(),
                                      Icon(Icons.delete),
                                      Text("Delete all notes"),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                itemCount: filteredNotes.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Changer la valeur pour définir la forme souhaitée
                                      side: const BorderSide(
                                          color: Colors.black,
                                          width:
                                              1), // Changer la couleur et la largeur des bords
                                    ),
                                    surfaceTintColor: Colors.red,
                                    child: Slidable(
                                      key: const ValueKey(0),

                                      // The start action pane is the one at the left or the top side.
                                      startActionPane: ActionPane(
                                        // A motion is a widget used to control how the pane animates.
                                        motion: const ScrollMotion(),

                                        // A pane can dismiss the Slidable.
                                        // dismissible: DismissiblePane(onDismissed: () {}),

                                        // All actions are defined in the children parameter.
                                        children: [
                                          // A SlidableAction can have an icon and/or a label.
                                          SlidableAction(
                                            onPressed:
                                                (BuildContext context) async {
                                              int noteIndex = i;
                                              int response = await widget.sqlDb
                                                  .delete("notes",
                                                      "id=${widget.notes[noteIndex]["id"]}");
                                              if (response > 0) {
                                                setState(() {
                                                  widget.notes
                                                      .removeAt(noteIndex);
                                                });
                                              }
                                            },
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),

                                      // The end action pane is the one at the right or the bottom side.
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            backgroundColor:
                                                const Color(0xFF0392CF),
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: 'Edit',
                                            onPressed:
                                                (BuildContext context) async {
                                              print("clicked edit");

                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditNotes(
                                                    note: widget.notes[i]
                                                        ["note"],
                                                    title: widget.notes[i]
                                                        ["title"],
                                                    date: widget.notes[i]
                                                        ["date"],
                                                    id: widget.notes[i]["id"],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),

                                      // The child of the Slidable is what the user sees when the
                                      // component is not dragged.
                                      child: ListTile(
                                        tileColor: Colors.yellow,
                                        leading: const Icon(Icons.swap_horiz),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${filteredNotes[i]['date']}",
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${filteredNotes[i]['title']}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle:
                                            Text("${filteredNotes[i]['note']}"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddNotesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const AddNotes();
  }
}

class FilterListTab extends StatefulWidget {
  final List<Map<String, dynamic>> notes;
  final SqlDb sqlDb;

  FilterListTab({
    required this.notes,
    required this.sqlDb,
  });

  @override
  State<FilterListTab> createState() => _FilterListTabState();
}

class _FilterListTabState extends State<FilterListTab> {
  late DateTime selectedDate;
  late List<Map<String, dynamic>> filteredNotes;
  bool dateClicked = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    filteredNotes = widget.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HorizontalCalendar(
          initialDate: DateTime(2023),
          lastDate: DateTime(2024),
          date: selectedDate,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          selectedColor: Colors.blue,
          showMonth: false,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
              String selectedDateString = DateFormat('d MMM yyyy').format(date);
              filteredNotes = widget.notes
                  .where((note) => note['date'] == selectedDateString)
                  .toList();
              dateClicked = true;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (!dateClicked) {
                    return Container(); // Afficher un conteneur vide si aucune date n'est sélectionnée
                  }

                  return filteredNotes.isEmpty
                      ? Visibility(
                          visible: true,
                          child: Column(
                            children: [
                              Lottie.asset(
                                'assets/images/noteanimation.json',
                                height: 360,
                              ),
                              const Text(
                                "You do not have any tasks for this date!",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredNotes.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                tileColor: Colors.yellow,
                                leading: const Icon(Icons.note),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${filteredNotes[i]['date']}",
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${filteredNotes[i]['title']}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text("${filteredNotes[i]['note']}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AccountNote extends StatefulWidget {
  const AccountNote({super.key});

  @override
  State<AccountNote> createState() => _AccountNoteState();
}

class _AccountNoteState extends State<AccountNote> {
  @override
  Widget build(BuildContext context) {
    return const HomePageFirebase();
  }
}
