import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/utility/firebase.repository.dart';
import 'package:todoapp/utility/firestore.repository.dart';
import 'package:todoapp/utility/sqlite.repository.dart';
import 'firebase_options.dart';

initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  await initializeFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FirebaseRepository()),
        RepositoryProvider(create: (_) => SqliteDBRepository()),
        RepositoryProvider(create: (_) => FirestoreRepository())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
