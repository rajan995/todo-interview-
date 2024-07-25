import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/screen/home/bloc/home.bloc.dart';
import 'package:todoapp/utility/firestore.repository.dart';
import 'package:todoapp/utility/sqlite.repository.dart';

initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {}
