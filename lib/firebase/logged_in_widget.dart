import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_package/firebase/google_sign_in.dart';

class LoggedInWidjet extends StatelessWidget {
  const LoggedInWidjet({super.key});

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
/*
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          "Loggot in",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile"),
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Name : ${user.displayName!}",
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Email : ${user.email!}"),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
*/