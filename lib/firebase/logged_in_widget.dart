import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_package/firebase/google_sign_in.dart';

class LoggedInWidjet extends StatefulWidget {
  const LoggedInWidjet({super.key});

  @override
  State<LoggedInWidjet> createState() => _LoggedInWidjetState();
}

class _LoggedInWidjetState extends State<LoggedInWidjet> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
            )
          ],
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: CustomClipperWidget(),
              child: Container(color: Colors.yellow),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user.displayName!,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ],
        ));
  }
}

class CustomClipperWidget extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height / 3);
    path.lineTo(size.width + 250, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
