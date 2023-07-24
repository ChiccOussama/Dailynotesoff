import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_package/firebase/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(left: 30),
            child: const Text(
              "Hi,",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: const Text(
              "Welcome Back !",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              "Daily Notes",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Container(
                padding: const EdgeInsets.only(left: 10),
                width: 350,
                height: 350,
                child: SvgPicture.asset(
                    "assets/images/undraw_mobile_login_re_9ntv.svg")),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SignInWithGoogle(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
              buttonColor: Colors.teal[400],
              fontColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
