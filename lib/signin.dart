import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_off_100/image.dart';

import 'package:one_off_100/textfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailcontrollor = TextEditingController();
  final TextEditingController passwordcontrollor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey.shade600,
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          const Icon(
            Icons.lock,
            size: 200,
            color: Colors.blueGrey,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Welcome Back, You had been missed',
            style: TextStyle(color: Colors.blueGrey, fontSize: 17),
          ),
          InputText(
            control: emailcontrollor,
            hinttext: 'Email',
            obsc: false,
          ),
          InputText(
            control: passwordcontrollor,
            hinttext: 'Password',
            obsc: true,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              minimumSize: Size(200, 60),
            ),
            onPressed: () {
              signin(emailcontrollor.text, passwordcontrollor.text);
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You do not have an account ? ',
                style: TextStyle(color: Colors.blueGrey, fontSize: 17),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  /*void usersignin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignUp(),
      ),
    );
  }*/

  void signin(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    var id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('UsersData')
        .doc(id)
        .set({'id': id, 'email': email, 'pasword': password});
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ImagePickerScreen()));
  }
}
