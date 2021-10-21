import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SignUpImplicitAnimation extends StatefulWidget {
  const SignUpImplicitAnimation({Key? key}) : super(key: key);

  @override
  State<SignUpImplicitAnimation> createState() =>
      _SignUpImplicitAnimationState();
}

class _SignUpImplicitAnimationState extends State<SignUpImplicitAnimation> {
  late bool isRegistering;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRegistering = false;
  }

  void changePage() {
    setState(() {
      isRegistering = !isRegistering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSwitcher(
      // reverseDuration: const Duration(milliseconds: 0),
      duration: const Duration(seconds: 1),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.fastOutSlowIn,
      layoutBuilder: (child, childrens) {
        return child!;
      },
      // outGoingTransitionBuilder: (child, animation) {
      //   return SlideTransition(
      //     position: Tween<Offset>(
      //             begin: const Offset(0, -0.05), end: const Offset(0, 0))
      //         .animate(animation),
      //     child: FadeTransition(opacity: animation, child: child),
      //   );
      // },
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(0, -0.05), end: const Offset(0, 0))
              .animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: isRegistering
          ? Register(changePage: changePage)
          : LogIn(changePage: changePage),
    ));
  }
}

class LogIn extends StatelessWidget {
  const LogIn({Key? key, required this.changePage}) : super(key: key);

  final void Function() changePage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Enter email"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Enter password"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Sign In"),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: changePage,
                child: const Text("Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Register extends StatelessWidget {
  const Register({Key? key, required this.changePage}) : super(key: key);

  final void Function() changePage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Register',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Enter email"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Enter password"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Sign Up"),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: changePage,
                child: const Text("Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
