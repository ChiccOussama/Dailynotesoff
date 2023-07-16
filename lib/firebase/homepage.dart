import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite_package/firebase/logged_in_widget.dart';
import 'package:sqflite_package/firebase/sign_up_widget.dart';

class HomePageFirebase extends StatelessWidget {
  const HomePageFirebase({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong!"));
              } else if (snapshot.hasData) {
                return const LoggedInWidjet();
              } else {
                return const SignUpWidget();
              }
            }),
      );
}
