import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/utility/firebase.repository.dart';

class DrawerScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        TextButton(
            onPressed: () {
              context.read<FirebaseRepository>().signout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: Text("Logout"))
      ],
    ));
  }
}
